//
//  SplashView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive = false
    
    var body: some View {
        Image("chat")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
    }
}
