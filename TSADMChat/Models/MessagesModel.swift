//
//  MessagesHelper.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 11/2/24.
//

import Foundation
import CloudKit

class MessagesModel: ObservableObject {
    @Published var messages: [Message] = []

    func sendMessage(_ message: String) async {
        do {
          try await CloudKitHelper().sendMessage(message)
            
            let newMessage = try await Message(id: UUID().uuidString, senderId: CloudKitHelper().myUserRecordID(), text: message)
            messages.append(newMessage)
        } catch {
          // Handle the error
          print("Error sending message: \(error)")
        }
    }
    
    func prepareMessages() -> Void {
        Task {
            do {
                _ = try await CloudKitHelper().myUserRecordID()
                try await CloudKitHelper().checkForSubscriptions()
                await CloudKitHelper().downloadMessages(from: nil, perRecord: convertMessages)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertMessages(recordID: CKRecord.ID, recordRes: Result<CKRecord, Error>) {
        switch (recordRes) {
        case .success(let record):
            if let messageText = record["text"] as? String {
                let senderId = record.creatorUserRecordID!.recordName
                let messageId = record.recordID.recordName
                
                let message = Message(id: messageId, senderId: senderId, text: messageText)
                
                messages.append(message)
            }
        case .failure:
            print("Failed to extract message from record.")
        }
    }
}
