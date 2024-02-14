//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI

struct BottomChatBar : View {
    @State var message: String = ""
    @ObservedObject var chatModel: ChatModel
    
    var body: some View {
        HStack {
                            TextField("Enviar mensaje", text: $message)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                guard message.count > 0 else { return }
                                Task {
                                    let sender = await chatModel.getUser()
                                    let senderName = chatModel.getUserName()
                                    let newMessage = MessageModel(id: UUID().uuidString, senderName: senderName, senderThumbnail: sender?.thumbnail, text: message)
                                    message = ""
                                        do {
                                            chatModel.messages.append(newMessage)
                                          try await CloudKitHelper().sendMessage(message)
                                        } catch {
                                          return
                                        }
                                }
                            } label: {
                                Image(systemName: "paperplane")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading, 10)
                            .disabled(message.count == 0)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .background(Color.cyan)
    }
}
