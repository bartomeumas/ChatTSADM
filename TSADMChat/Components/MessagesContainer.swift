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
    @ObservedObject var chatModel: ChatModel
    @State var username: String = ""
    @Namespace var bottomID

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    if chatModel.messages.isEmpty {
                        Text("Cargando mensajes...")
                    } else {
                        ForEach(chatModel.messages, id: \.self) { message in
                            MessageBubble(message: message.text, sender: message.sender)
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
                .onChange(of: chatModel.messages) { _ in
                    withAnimation {
                        proxy.scrollTo(bottomID)
                    }
                }
                .onChange(of: chatModel.users) { _ in
                    print(chatModel.users)
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
