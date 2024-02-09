import SwiftUI
import CloudKit
import PhotosUI

struct ProfileView: View {
  @State var imageSelection: PhotosPickerItem? = nil
  @State var uiImage: UIImage? = nil

  var body: some View {
    VStack {
      Image(uiImage: uiImage ?? UIImage())
        .resizable()
        .scaledToFill()
        .frame(width: 200, height: 200)
        .clipped()
        .background(Color.gray.opacity(0.2))
      photoPickerButton
    }
    .onChange(of: imageSelection) {
        Task { @MainActor in
            if let data = try? await imageSelection?.loadTransferable(type: Data.self) {
                uiImage = UIImage(data:data)
                
                try await CloudKitHelper().updateUser(newName: nil, thumbnail: uiImage?.toCKAsset(name: "profilepic"))
                return
            }
        }
    }
  }

    var photoPickerButton: some View {
      PhotosPicker(
        selection: $imageSelection,
        matching: .images,
        photoLibrary: .shared()) {
          Image(systemName: "camera.circle.fill")
            .font(.system(size: 50))
            .foregroundColor(.gray)
        }
        .photosPickerStyle(.inline)
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
            print("Error converting UIImage to CKAsset!")
        }
        return nil
    }
}
