//
//  ProfileModel.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 11/2/24.
//

import Foundation
import PhotosUI
import SwiftUI

class ProfilePicModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() }}
    }
    
    @Published var profileImage: Image?
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
        try await CloudKitHelper().updateUser(newName: nil, thumbnail: uiImage.toCKAsset(name: "profilepic"))
    }
}
