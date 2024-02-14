//
//  MessageBubble.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 2/2/24.
//

import SwiftUI

struct MessageBubble: View {
    var message: String
    @State var senderName: String
    @State var senderThumbnail: UIImage?
    @ObservedObject var chatModel: ChatModel

    var body: some View {
        HStack {
            if senderName == chatModel.getUserName() {
                Spacer()
                if (senderThumbnail != nil) {
                    Image(uiImage: senderThumbnail!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundColor(Color(.systemBlue))
                }
                VStack {
                    Text(senderName)
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
                if (senderThumbnail != nil) {
                    Image(uiImage: senderThumbnail!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundColor(Color(.systemBlue))
                }
                VStack {
                    Text(senderName)
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
