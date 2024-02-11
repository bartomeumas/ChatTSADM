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
    @StateObject var loginService = LoginService()
    @ObservedObject var messagesService = MessagesService()
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
                if loginService.isLoggedIn {
                    ChatView(messagesService: messagesService)
                }
                else {
                    LoginView(loginService: loginService)
                }
            }
            else {
                SplashView()
            }
        }
        .onAppear {
            Task {
                let userName = loginService.getUser()
                
                if (userName.isEmpty == false) {
                    await loginService.login(userName: userName)
                }
                messagesService.prepareMessages()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isActive = true
                }
            }
        }
    }
}
