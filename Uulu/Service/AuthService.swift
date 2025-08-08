//
//  AuthService.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import Foundation
import FirebaseAuth
import Combine

enum AuthState {
    case signedIn(UserModel)
    case signedOut
}

final class AuthService {
    static let shared = AuthService()
    var authState = CurrentValueSubject<AuthState, Never>(.signedOut)
    var databaseService = DatabaseService()
    
    private init() {
        Task {
            try await autoLogin()
        }
    }
    
    func autoLogin() async throws {
        if Auth.auth().currentUser == nil {
            authState.send(.signedOut)
        } else {
            guard let currentUser = Auth.auth().currentUser else { return }
            let user = try await databaseService.fetchUserFromDatabase(currentUser.uid)
            authState.send(.signedIn(user))
        }
    }
    
    func signIn(_ email: String, _ password: String) async -> Bool {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = try await databaseService.fetchUserFromDatabase(authResult.user.uid)
            authState.send(.signedIn(user))
            return true
        } catch {
            print("Failed to sign in - \(error.localizedDescription)")
            return false
        }
    }
    
    func signUp(_ username: String, _ email: String, _ password: String) async -> Bool {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = UserModel(authResult.user, username)
            try await databaseService.saveUserInDatabase(user)
            authState.send(.signedIn(user))
            return true
        } catch {
            print("Failed to sign up - \(error.localizedDescription)")
            return false
        }
    }
    
    func resetPassword(_ email: String) async {
        try? await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        authState.send(.signedOut)
    }
}

//final class SocialAuthService {
//    func signInWithGoogle() async throws {
//        
//    }
//    
//    func signInWithTwitter() async throws {
//        
//    }
//}

final class DatabaseService {
    func saveUserInDatabase(_ user: UserModel) async throws {
        let ref = FBConstants.usersRef.document(user.id)
        let snapshot = try await ref.getDocument()
        
        if !snapshot.exists {
            try ref.setData(from: user)
        }
    }
    
    func fetchUserFromDatabase(_ uid: String) async throws -> UserModel {
        return try await FBConstants.usersRef.document(uid).getDocument(as: UserModel.self)
    }
}
