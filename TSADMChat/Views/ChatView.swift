//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct ChatView: View {
    @ObservedObject var messagesModel: MessagesModel
    @State var username: String = LoginModel().getUser()
    
    var body: some View {
        VStack {
            TopChatBar(username: username)
            MessagesContainer(messagesModel: messagesModel, username: username)
            BottomChatBar(messagesModel: messagesModel)
            }
    }
}
