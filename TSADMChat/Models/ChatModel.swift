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
              try await CloudKitHelper().sendMessage(message)
            } catch {
              return
            }
        }

    private func prepareMessages() async {
        do {
            _ = try await CloudKitHelper().myUserRecordID()
            try await CloudKitHelper().checkForSubscriptions()
            await CloudKitHelper().downloadMessages(from: nil, perRecord: convertMessages)
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
