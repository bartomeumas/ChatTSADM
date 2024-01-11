//
//  ContentView.swift
//  TSADMChat
//
//  Created by Gabriel Marro on 20/11/23.
// Based on article by Uday P.
// https://udaypatial.medium.com/scroll-to-bottom-of-a-list-of-items-swiftui-21ade9f2d46b
//

import SwiftUI

struct ContentView: View {
    
    @State private var message: String = ""
    @State var messages: [String] = []
    @State var isActive = false
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        ZStack {
            if self.isActive {
                //ChatView()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isActive = true
                }
            }
        }
    }
}

struct MessageBubble: View {
    var message: String
    var sender: String = "Juan Luis"
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(sender)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                Text(message)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    
            }
            .padding(10)
            .background(Color.green)
            .cornerRadius(20)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView()
}
