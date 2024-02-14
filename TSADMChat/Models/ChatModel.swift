import Foundation
import CloudKit

class ChatModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var messages: [MessageModel] = []
    @Published var isLoggedIn = false
    @Published var username = ""

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
    
    func login(userName: String) async {
        do {
            try await CloudKitHelper().updateUser(newName: userName, thumbnail: nil)
            UserDefaults.standard.set(userName, forKey: "username")
            isLoggedIn = true
            username = userName
        }
        catch {
            isLoggedIn = false
        }
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    func getUser() async ->  UserModel? {
        do {
            let id = try await CloudKitHelper().myUserRecordID()
            return users.first(where: {$0.id == id}) ?? UserModel(id: "1", name: "", thumbnail: nil)
        } catch {
            return UserModel(id: "1", name: "", thumbnail: nil)
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
                    
                    let message = MessageModel(id: messageId, senderName: sender.name, senderThumbnail: sender.thumbnail, text: messageText)
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
