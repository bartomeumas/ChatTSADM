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
    @Published private var user: String = ""
    
    func login(userName: String) async -> String {
        isLoggedIn = true
        return "barto"
    }
    
    func getUser() -> String{
        return user
    }
}
