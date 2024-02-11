//
//  MessagesHelper.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 11/2/24.
//

import Foundation
import CloudKit

class MessagesModel: ObservableObject {
    @Published var messages: [String] = []

    func sendMessage(_ message: String) async {
        do {
          try await CloudKitHelper().sendMessage(message)
            messages.append(message)
        } catch {
          // Handle the error
          print("Error sending message: \(error)")
        }
    }
    
    func prepareMessages() -> Void {
        Task {
            do {
                _ = try await CloudKitHelper().myUserRecordID()
//                try await CloudKitHelper().checkForSubscriptions()
                await CloudKitHelper().downloadMessages(from: nil, perRecord: convertMessages)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertMessages(recordID: CKRecord.ID, recordRes: Result<CKRecord, Error>) {
        switch (recordRes) {
        case .success(let record):
            if let message = record["text"] as? String {
                messages.append(message)
            }
        case .failure:
            print("Failed to extract message from record.")
        }
    }
}
