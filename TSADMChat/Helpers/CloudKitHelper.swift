//
//  CloudKitHelper.swift
//  TSADMChat
//
//  Created by Gabriel Marro on 22/11/23.
//

import Foundation
import CloudKit

struct CloudKitHelper {
    
    static let subscriptionID = "NEW_MESSAGE"
    
    enum FetchError: Error {
            case recordNotFound
            case cloudKitError(Error)
        }
    
    public func myUserRecordID() async throws -> String {
        let container = CKContainer.default()
        let record = try await container.userRecordID()
        
        return record.recordName
    }
    
    func fetchUserInfo(userId: String, completion: @escaping (Result<(name: String, thumbnail: CKAsset?), FetchError>) -> Void) {
        let recordID = CKRecord.ID(recordName: userId)

        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                completion(.failure(.cloudKitError(error)))
                return
            }

            guard let record = record else {
                completion(.failure(.recordNotFound))
                return
            }

            // Retrieve name and thumbnail (with error handling)
            guard let name = record["name"] as? String else {
                completion(.failure(.recordNotFound))
                return
            }

            let thumbnail = record["thumbnail"] as? CKAsset

            completion(.success((name: name, thumbnail: thumbnail)))
        }
    }

 
    public func updateUser(newName: String?, thumbnail: CKAsset?) async throws -> Result<Void, Error> {
        let recordID = try await myUserRecordID()
        let container = CKContainer.default()
        let db = container.publicCloudDatabase

        do {
            let record = try await db.record(for: CKRecord.ID(recordName: recordID))
            
            if (newName != nil) {
                record["name"] = newName
            }
            if (thumbnail != nil) {
                record["thumbnail"] = thumbnail
            }
            
            try await db.save(record)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    public func downloadMessages(from: Date?,
                          perRecord: @escaping (_ recordID: CKRecord.ID, _ recordResult: Result<CKRecord, Error>) -> Void) async -> Error? {
        
        await withCheckedContinuation { continuation in
            let container = CKContainer.default()
            let db = container.publicCloudDatabase
            let predicate: NSPredicate
            if let date = from {
                predicate = NSPredicate(format: "creationDate > %@", date as NSDate)
            } else {
                predicate = NSPredicate(value: true)
            }
            
            let query = CKQuery(recordType: "Message", predicate: predicate)
            query.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true)]
            
            func completion(_ operationResult: Result<CKQueryOperation.Cursor?, Error>) {
                switch operationResult {
                case .success(let cursor):
                    if let cursor = cursor {
                        let newOp = CKQueryOperation(cursor: cursor)
                        newOp.recordMatchedBlock = perRecord
                        newOp.queryResultBlock = completion
                        db.add(newOp)
                    } else {
                        continuation.resume(returning: nil)
                    }
                    break
                case .failure(let error):
                    continuation.resume(returning: error)
                    break
                }
            }
            
            let queryOp = CKQueryOperation(query: query)
            //queryOp.recordFetchedBlock = perRecord
            queryOp.recordMatchedBlock = perRecord
            queryOp.queryResultBlock = completion
            db.add(queryOp)
        }
    }
    
    public func sendMessage(_ text: String) async throws {
        let message = CKRecord(recordType: "Message")
        message["text"] = text as NSString
        let db = CKContainer.default().publicCloudDatabase
        try await db.save(message)
    }
    
    public func subscribeToNotifications() {
      let predicate = NSPredicate(value: true)
      let subscription = CKQuerySubscription(recordType: "Message", predicate: predicate, subscriptionID: CloudKitHelper.subscriptionID, options: .firesOnRecordCreation)
      let notification = CKSubscription.NotificationInfo()

      notification.soundName = "chan.aiff"
      notification.title = "New message"
      notification.alertBody = "%K"
      notification.soundName = "default"
      subscription.notificationInfo = notification
        
      CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
        if let error = returnedError {
          print(error)
        } else {
          print("Subscribed")
        }
      }
    }
  
    public func checkForSubscriptions() async throws -> CKSubscription? {
        let db = CKContainer.default().publicCloudDatabase
        let subscriptions = try await db.allSubscriptions()
        if !subscriptions.contains(where: { subscription in
            subscription.subscriptionID == CloudKitHelper.subscriptionID
        }) {
            let options:CKQuerySubscription.Options
            options = [.firesOnRecordCreation]
            let predicate = NSPredicate(value: true)
            let subscription = CKQuerySubscription(recordType: "Message",
                                                   predicate: predicate,
                                                   subscriptionID: CloudKitHelper.subscriptionID,
                                                   options: options)
            let info = CKSubscription.NotificationInfo()
            info.soundName = "chan.aiff"
            info.alertBody = "New message"
            
            subscription.notificationInfo = info
            
            return try await db.save(subscription)
        }
        return nil
    }
}
