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
    let center = UNUserNotificationCenter.current()
    
    init() {
           center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
               if let error = error {
                   print(error)
                   // Handle the error here.
               } else {
                   CloudKitHelper().subscribeToNotifications()
               }
           })
       }

    var body: some View {
        ZStack {
            if self.isActive {
                if loginModel.isLoggedIn {
                    ChatView(messagesModel: messagesModel)
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
                let userName = loginModel.getUser()
                
                if (userName.isEmpty == false) {
                    await loginModel.login(userName: userName)
                }
                messagesModel.prepareMessages()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isActive = true
                }
            }
        }
    }
}
