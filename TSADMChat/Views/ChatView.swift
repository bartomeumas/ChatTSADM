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
    
    var body: some View {
        VStack {
            TopChatBar(chatModel: chatModel)
            MessagesContainer(chatModel: chatModel, username: chatModel.getUserName())
            BottomChatBar(chatModel: chatModel)
            }
    }
}
