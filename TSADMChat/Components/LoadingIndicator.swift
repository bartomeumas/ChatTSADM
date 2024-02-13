//
//  LoadingIndicator.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 13/2/24.
//

import Foundation
import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        VStack {
            ProgressView()
                .frame(width: 50, height: 50)
                .foregroundColor(.black)

            Text("Loading...")
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.5))
        .cornerRadius(10.0)
    }
}
