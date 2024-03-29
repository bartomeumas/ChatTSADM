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
    @ObservedObject var chatModel = ChatModel(cloudKitHelper: CloudKitHelper())
    
    let center = UNUserNotificationCenter.current()
    
    init() {
        self.chatModel = ChatModel(cloudKitHelper: CloudKitHelper())
           center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
               if let error = error {
                   print(error)
                   // Handle the error here.
               }else if granted{
                   print("Notification granted")
                   
                   DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
                   
               }else{
                   print("Notification failed")
               }
           })
       }

    var body: some View {
        ZStack {
            if self.isActive {
                if chatModel.isLoggedIn {   
                    ChatView(chatModel: chatModel)
                }
                else {
                    LoginView(chatModel: chatModel)
                }
            }
            else {
                SplashView()
            }
        }
        .onAppear {
            Task {
                await chatModel.prepareData()
                let userName = chatModel.getUserName()

                if (userName.isEmpty == false) {
                    await chatModel.login(userName: userName)
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
