//
//  UserModel.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import Foundation
import FirebaseAuth

struct UserModel: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    
    static let placeholder = UserModel(id: "1", username: "Dmitry", email: "dmitry@test.com")
}

extension UserModel {
    init(_ user: User, _ username: String) {
        self.id = user.uid
        self.email = user.email ?? "Unknown"
        self.username = username
    }
}
