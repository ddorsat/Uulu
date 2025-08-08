//
//  FirebaseConstants.swift
//  Uulu
//
//  Created by ddorsat on 26.06.2025.
//

import Foundation
import FirebaseFirestore

struct FBConstants {
    static let databaseRef = Firestore.firestore()
    static let usersRef = databaseRef.collection("users")
    static let productsRef = databaseRef.collection("products")
    static let brandsRef = databaseRef.collection("brands")
    static let ordersRef = databaseRef.collection("orders")
}

struct FBService {
    static func upload<T: Codable>(ref: DocumentReference, model: T) async throws {
        let snapshot = try await ref.getDocument()
        if !snapshot.exists {
            try ref.setData(from: model)
        }
    }
    
    static func addToFavorites(ref: DocumentReference, currentUid: String) async throws {
        let snapshot = try await ref.getDocument()
        
        let favorites = snapshot["favorites"] as? [String] ?? []
        let update = favorites.contains(currentUid)
            ? ["favorites": FieldValue.arrayRemove([currentUid])]
            : ["favorites": FieldValue.arrayUnion([currentUid])]
        
        try await ref.updateData(update)
    }
    
    static func listenTo<T: Decodable>(snapshot: QuerySnapshot?, completion: ([T]) -> Void) {
        guard let documents = snapshot?.documents else { return }
        
        let products = documents.compactMap { try? $0.data(as: T.self) }
        completion(products)
    }
}

