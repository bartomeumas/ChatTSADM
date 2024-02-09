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
    @State private var selectedImage: UIImage?

    func login(userName: String) async {
        do {
            try await CloudKitHelper().updateUser(newName: userName, thumbnail: nil)
                UserDefaults.standard.set(userName, forKey: "username")
            isLoggedIn = true
        }
        catch {
            isLoggedIn = false
        }
    }
    
    public func getUser() -> String {
        let user: String = UserDefaults.standard.string(forKey: "username") ?? ""

        return user
    }
}
