//
//  MessageBubble.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 2/2/24.
//

import SwiftUI

struct MessageBubble: View {
    var message: String
    @State var sender: String

    var body: some View {
        HStack {
            if sender == LoginModel().getUser() {
                // Sender's message: Spacer on the left
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
            } else {
                // Recipient's message: Spacer on the right
                VStack {
                    Text(sender)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.leading)
                    Text(message)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                }
                .padding(10)
                .background(Color.blue)
                .cornerRadius(20)
                .foregroundStyle(.white)
                Spacer()
            }
        }
    }
}
