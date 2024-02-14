//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI

struct TopChatBar : View {
    @State var chatModel: ChatModel
    @State var userName = ""
    @State var thumbnail: UIImage?
    
    var body: some View {
        HStack {
            Text(userName)
            Spacer()
            if (thumbnail != nil) {
                Image(uiImage: (thumbnail)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: 50)
        .font(.largeTitle)
        .background(Color.cyan)
        .foregroundColor(Color.white)
        .onAppear {
            Task {
                userName = chatModel.getUserName()
                let user = await chatModel.getUser()
                
                thumbnail = user?.thumbnail
            }
        }
    }
}
