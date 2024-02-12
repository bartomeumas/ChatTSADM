//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct ChatView: View {
    @ObservedObject var chatModel: ChatModel
    @State var username: String = LoginModel().getUser()
    
    var body: some View {
        VStack {
            TopChatBar(username: username)
            MessagesContainer(chatModel: chatModel, username: username)
            BottomChatBar(chatModel: chatModel)
            }
    }
}
