//
//  Message.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 12/2/24.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Hashable {
    let id: String // Unique identifier for the message
    let name: String
    let thumbnail: Image?

    init(id: String, name: String, thumbnail: Image?) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }

    // Implement the hashValue property:
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use the unique identifier for hashing
    }

    // Also implement the == operator for comparison:
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id // Compare based on the unique identifier
    }
    
    
}
