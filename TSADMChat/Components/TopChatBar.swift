//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI

struct TopChatBar : View {
    @State var username: String = ""
    
    var body: some View {
        HStack {
            Text(username)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: 50)
        .font(.largeTitle)
        .background(Color.cyan)
        .foregroundColor(Color.white)
    }
}
