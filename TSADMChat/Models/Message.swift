//
//  Message.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 12/2/24.
//

import Foundation
import PhotosUI

struct MessageModel: Identifiable, Hashable {
    let id: String // Unique identifier for the message
    let senderName: String
    let senderThumbnail: UIImage?
    let text: String

    init(id: String, senderName: String, senderThumbnail: UIImage?, text: String) {
        self.id = id
        self.senderName = senderName
        self.senderThumbnail = senderThumbnail
        self.text = text
    }

    // Implement the hashValue property:
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use the unique identifier for hashing
    }

    // Also implement the == operator for comparison:
    static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id // Compare based on the unique identifier
    }
}
