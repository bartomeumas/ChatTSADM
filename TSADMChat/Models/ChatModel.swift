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
                case .success(let user):
                    users.append(UserModel(id: id, name: user.name, thumbnail: user.thumbnail?.toUIImage()))
                case .failure:
                    return
                }
            }
        }
    }
    
    func sendMessage(_ message: String) async {
        let newMessage = Message(id: UUID().uuidString, senderName: LoginModel().getUser(), senderThumbnail: nil, text: message)
        
        messages.append(newMessage)
            do {
              try await cloudKitHelper.sendMessage(message)
            } catch {
              return
            }
        }

    private func prepareMessages() async {
        do {
            _ = try await cloudKitHelper.myUserRecordID()
            try await cloudKitHelper.checkForSubscriptions()
            await cloudKitHelper.downloadMessages(from: nil, perRecord: convertMessages)
        } catch {
            return
        }
    }

    private func convertMessages(recordID: CKRecord.ID, recordRes: Result<CKRecord, Error>) {
        switch recordRes {
        case .success(let record):
            if let messageText = record["text"] as? String,
               let senderId = record.creatorUserRecordID?.recordName {
                if let sender = users.first(where: { $0.id == senderId }) {
                    let messageId = record.recordID.recordName
                    
                    let message = Message(id: messageId, senderName: sender.name, senderThumbnail: sender.thumbnail, text: messageText)
                    messages.append(message)
                } else {
                    return
                }
            } else {
                return
            }
        case .failure:
            return
        }
    }
}
