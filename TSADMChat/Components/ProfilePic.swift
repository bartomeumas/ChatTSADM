//
//  ProfilePic.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 11/2/24.
//

import Foundation
import SwiftUI
import CloudKit
import PhotosUI

struct ProfilePic: View {
    @StateObject var profilePic = ProfilePicModel()
    
    var body: some View {
        PhotosPicker(selection: $profilePic.selectedItem) {
            if let profileImage = profilePic.profileImage {
                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(.systemBlue))
            }
        }
    }
}

extension UIImage {
    func toCKAsset(name: String? = nil) -> CKAsset? {
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        guard let imageFilePath = NSURL(fileURLWithPath: documentDirectory)
                .appendingPathComponent(name ?? "asset#\(UUID.init().uuidString)")
        else {
            return nil
        }
        do {
            try self.pngData()?.write(to: imageFilePath)
            return CKAsset(fileURL: imageFilePath)
        } catch {
            return nil
        }
        return nil
    }
}

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL!) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
