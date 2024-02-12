//
//  MessagesHelper.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 11/2/24.
//

import Foundation
import CloudKit

class UsersModel: ObservableObject {
    @Published var users: [UserModel] = []

    func prepareUsers() {
            for id in userIds {
                CloudKitHelper().fetchUserInfo(userId: id) { [self] result in
                    switch result {
                    case .success(let name):
                        print(name)
                        users.append(UserModel(id: id, name: name, thumbnail: nil))
                    case .failure(let error):
                        print("No user name found \(id): \(error)")
                    }
                }
            }
        }
}
