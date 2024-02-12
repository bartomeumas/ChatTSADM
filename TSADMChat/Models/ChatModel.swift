import Foundation
import CloudKit

class ChatModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var messages: [Message] = []

    func prepareData() async {
        prepareUsers()
        await prepareMessages()
    }

    private func prepareUsers() {
        for id in userIds {
            CloudKitHelper().fetchUserInfo(userId: id) { [self] result in
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
              try await CloudKitHelper().sendMessage(message)
                
                let newMessage = Message(id: UUID().uuidString, sender: LoginModel().getUser(), text: message)
                messages.append(newMessage)
            } catch {
              // Handle the error
              print("Error sending message: \(error)")
            }
        }

    private func prepareMessages() async {
        do {
            _ = try await CloudKitHelper().myUserRecordID()
            try await CloudKitHelper().checkForSubscriptions()
            await CloudKitHelper().downloadMessages(from: nil, perRecord: convertMessages)
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
