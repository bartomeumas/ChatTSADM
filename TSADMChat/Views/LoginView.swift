//
//  LoginView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct LoginView: View {
    @ObservedObject var loginModel : LoginModel
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ProfilePic()
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
                        print("login")
                        await loginModel.login(userName: username)
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
