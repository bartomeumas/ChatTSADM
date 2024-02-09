//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI

struct BottomChatBar : View {
    @Binding var message: String
    @State var messages: [String] = []
    
    var body: some View {
        HStack {
                            TextField("Send a message", text: $message)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                guard message.count > 0 else {
                                              return
                                            }
                                             
                                            Task {
                                                do {
                                                  try await CloudKitHelper().sendMessage(message)
                                                    messages.append(message)
                                                  message = ""
                                                } catch {
                                                  // Handle the error
                                                  print("Error sending message: \(error)")
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
