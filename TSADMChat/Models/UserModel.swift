//
//  Message.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 12/2/24.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Hashable {
    let id: String
    let name: String
    let thumbnail: UIImage?

    init(id: String, name: String, thumbnail: UIImage?) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func getProfilePic(userName: String) {
        
    }
}
