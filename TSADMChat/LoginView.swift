//
//  LoginView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct LoginView: View {
    @State var username: String = ""
    @State private var image: Image? = Image("user")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @ObservedObject var loginManager : LoginManager

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ProfileIconView()
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
                        do {
                             await loginManager.login(userName: username)
                            try await CloudKitHelper().updateUser(newName: "BartomeuMas")
                        } catch {
                            // Handle any errors that may occur during insertion
                            print("Failed to insert user: \(error)")
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
