//
//  ContentView.swift
//  TSADMChat
//
//  Created by Gabriel Marro on 20/11/23.
// Based on article by Uday P.
// https://udaypatial.medium.com/scroll-to-bottom-of-a-list-of-items-swiftui-21ade9f2d46b
//

import SwiftUI
import CloudKit
import UserNotifications

struct ContentView: View {
    
    @State var isActive = false
    @StateObject var loginModel = LoginModel()
    @ObservedObject var messagesModel = MessagesModel()
    @ObservedObject var usersModel = UsersModel()
    let center = UNUserNotificationCenter.current()
    
    init() {
           center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
               if let error = error {
                   print(error)
                   // Handle the error here.
               }
           })
       }

    var body: some View {
        ZStack {
            if self.isActive {
                if loginModel.isLoggedIn {
                    ChatView(messagesModel: messagesModel, usersModel: usersModel)
                }
                else {
                    LoginView(loginModel: loginModel)
                }
            }
            else {
                SplashView()
            }
        }
        .onAppear {
            Task {
                try await CloudKitHelper().checkForSubscriptions()
                                
                usersModel.prepareUsers()
                messagesModel.prepareMessages()
                
                let userName = loginModel.getUser()
                
                if (userName.isEmpty == false) {
                    await loginModel.login(userName: userName)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isActive = true
                }
            }
        }
    }
}
