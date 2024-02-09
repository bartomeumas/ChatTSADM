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
                .background(sender == LoginManager().getUser() ? Color.green : Color.blue)
                .cornerRadius(20)
                .foregroundStyle(.white)
            }
        }
    }
