//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct ChatView: View {
    @State private var message: String = ""
    @State var messages: [String] = []
    @State var username: String = LoginManager().getUser()
    
    var body: some View {
        VStack {
            TopChatBar(username: username)
                    MessagesContainer(messages: messages, username: username)
            Spacer()
            BottomChatBar(message: $message, messages: messages)
            }
    }
}
