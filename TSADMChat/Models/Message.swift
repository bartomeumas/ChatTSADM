//
//  Message.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 12/2/24.
//

import Foundation

struct Message: Identifiable, Hashable {
    let id: String // Unique identifier for the message
    let senderId: String
    let text: String

    init(id: String, senderId: String, text: String) {
        self.id = id
        self.senderId = senderId
        self.text = text
    }

    // Implement the hashValue property:
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use the unique identifier for hashing
    }

    // Also implement the == operator for comparison:
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id // Compare based on the unique identifier
    }
}
