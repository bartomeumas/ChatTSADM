//
//  LoginManager.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 13/12/23.
//
import SwiftUI
import CloudKit

class LoginManager : ObservableObject {
    @Published var isLoggedIn = false
    
    func login(userName: String = "user200") {
        let userRecord = CKRecord(recordType: "Users")
        userRecord["name"] = userName as CKRecordValue

        let database = CKContainer.default().publicCloudDatabase
        
        self.isLoggedIn = true
        
        database.save(userRecord) { (record, error) in
            if let error = error {
                print("Error saving record: \(error.localizedDescription)")
            } else {
                print("Record saved successfully")
            }
        }
    }
}
