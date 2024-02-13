import Foundation
import CloudKit

class ChatModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var messages: [Message] = []

    init(cloudKitHelper: CloudKitHelper) {
        self.cloudKitHelper = cloudKitHelper
    }
    
    var cloudKitHelper: CloudKitHelper
    
    func prepareData() async {
        cloudKitHelper = CloudKitHelper()
        prepareUsers()
        await prepareMessages()
        await subscribeNotificacion()
    }

    private func subscribeNotificacion() async {
        do {
            await cloudKitHelper.subscribeToNotifications()
        }catch {
            print("error on method subscribe notification")
        }
    }
    
    private func prepareUsers() {
        for id in userIds {
            cloudKitHelper.fetchUserInfo(userId: id) { [self] result in
                switch result {
                case .success(let name):
                    print(name)
                    users.append(UserModel(id: id, name: name, thumbnail: nil))
                case .failure(let error):
                    print("No user name found \(id): \(error)")
                }
            }
        }
    }
    
    func sendMessage(_ message: String) async {
        
            do {
              try await cloudKitHelper.sendMessage(message)
                
                let newMessage = Message(id: UUID().uuidString, sender: LoginModel().getUser(), text: message)
                messages.append(newMessage)
            } catch {
              // Handle the error
              print("Error sending message: \(error)")
            }
        }

    private func prepareMessages() async {
        do {
            _ = try await cloudKitHelper.myUserRecordID()
            try await cloudKitHelper.checkForSubscriptions()
            await cloudKitHelper.downloadMessages(from: nil, perRecord: convertMessages)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func convertMessages(recordID: CKRecord.ID, recordRes: Result<CKRecord, Error>) {
        switch recordRes {
        case .success(let record):
            if let messageText = record["text"] as? String,
               let senderId = record.creatorUserRecordID?.recordName {
                if let senderName = users.first(where: { $0.id == senderId })?.name {
                    let messageId = record.recordID.recordName
                    let message = Message(id: messageId, sender: senderName, text: messageText)
                    messages.append(message)
                } else {
                    print("Sender name not found for ID: \(senderId)")
                }
            } else {
                print("Failed to extract message from record.")
            }
        case .failure(let error):
            print("Failed to fetch message: \(error)")
        }
    }
}
