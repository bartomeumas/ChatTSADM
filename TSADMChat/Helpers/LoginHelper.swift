//
//  LoginManager.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 13/12/23.
//
import SwiftUI
import CloudKit
import PhotosUI

class LoginManager : ObservableObject {
    @Published var isLoggedIn = false
    @Published private var user: String = ""
    @State private var selectedImage: UIImage?

    func login(userName: String, imageAsset: CKAsset) async {
        do {
                try await CloudKitHelper().updateUser(newName: userName, imageAsset: imageAsset)
                UserDefaults.standard.set(userName, forKey: "username")
            isLoggedIn = true
        }
        catch {
            isLoggedIn = false
        }
    }
    
    func getUser() -> String{
        return user
    }
}
