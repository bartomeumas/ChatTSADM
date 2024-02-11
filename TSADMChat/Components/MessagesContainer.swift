//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

struct MessagesContainer : View {
    @ObservedObject var messagesService: MessagesService
    @State var username: String = ""
    @Namespace var bottomID

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    if messagesService.messages.isEmpty {
                        Text("Cargando mensajes...")
                    } else {
                        ForEach(messagesService.messages, id: \.self) { message in
                            MessageBubble(message: message, sender: username)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .padding([.leading, .trailing], 20)
                    }
                    Spacer()
                        .frame(height: 1)
                        .id(bottomID)
                }
                .frame(maxWidth: .infinity)
                .onChange(of: messagesService.messages) { _ in
                    withAnimation {
                        proxy.scrollTo(bottomID)
                    }
                }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(bottomID)
                    }
                }
            }
        }
        }
    }

