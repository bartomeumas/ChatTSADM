//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct ChatView: View {
    @ObservedObject var messagesService: MessagesService
    @State var username: String = LoginService().getUser()
    
    var body: some View {
        VStack {
            TopChatBar(username: username)
            MessagesContainer(messagesService: messagesService, username: username)
            BottomChatBar(messagesService: messagesService)
            }
    }
}
