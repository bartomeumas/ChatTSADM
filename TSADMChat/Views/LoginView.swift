//
//  LoginView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct LoginView: View {
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @ObservedObject var loginManager : LoginManager
    @StateObject var viewModel = ImageModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                // Camera button should go here
                EditableCircularProfileImage(viewModel: viewModel)
                Spacer()
                    .frame(height: 20)
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                    .frame(height: 20)
                Button {
                    Task {
                        switch viewModel.imageState {
                        case .success(let image):
                            try? image.write(to: URL(fileURLWithPath: "/tmp/profile_image.jpg"))

                               let imageAsset = CKAsset(fileURL: URL(fileURLWithPath: "/tmp/profile_image.jpg"))

                                await loginManager.login(userName: username, imageAsset: imageAsset)
                        case .loading:
//                            ProgressView()
                            print("")
                        case .empty:
//                            Image(systemName: "person.fill")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
                            print("")
                        case .failure:
                           print("")
                        }
                        
                    }
                } label: {
                    HStack {
                        Text("Login")
                            .padding(10)
                            .font(.system(size: 20))
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(10)
                    }
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.blue)
                        )
                    )
                    .disabled(username.isEmpty)
                }
                Spacer()
            }
        }
    }
}
