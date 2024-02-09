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
    
    @State private var message: String = ""
    @State var messages: [String] = []
    @State var isActive = false
    @StateObject var loginManager = LoginManager()
//    let persistenceController = PersistenceController.shared
        let center = UNUserNotificationCenter.current()
    
    init() {
           center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
               if let error = error {
                   print(error)
                   // Handle the error here.
               }
               // Enable or disable features based on the authorization.
           })
       }
    
    var body: some View {
        ZStack {
            if self.isActive {
                if loginManager.isLoggedIn {
                    ChatView()
                }
                else {
                    LoginView(loginManager: loginManager)
                }
            }
            else {
                SplashView()
            }
        }
        .onAppear {
            Task {
                let userName = loginManager.getUser()
                
                if (userName.isEmpty == false) {
                    await loginManager.login(userName: userName)
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
