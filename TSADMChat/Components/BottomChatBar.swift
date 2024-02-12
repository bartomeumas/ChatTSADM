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
                            TextField("Send a message", text: $message)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                guard message.count > 0 else { return }
                                Task {
                                    await chatModel.sendMessage(message)
                                    message = ""
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
