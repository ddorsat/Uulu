//
//  FavoritesService.swift
//  Uulu
//
//  Created by ddorsat on 21.07.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

final class FavoritesService {
    static let shared = FavoritesService()
    
    private var favoritesListener: ListenerRegistration? = nil
    
    deinit {
        favoritesListener = nil
        favoritesListener?.remove()
    }
    
    func addToFavoriteProducts(product: ProductModel) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let favoritesRef = FBConstants.usersRef.document(currentUid).collection("favorite_products").document(product.id)
        do {
            let snapshot = try await favoritesRef.getDocument()
            if snapshot.exists {
                try await favoritesRef.delete()
            } else {
                let data: [String: Any] = [
                    "product_id": product.id,
                    "min_price": product.minPrice,
                    "date_created": Timestamp()]
                try await favoritesRef.setData(data)
            }
            
            let productsRef = FBConstants.productsRef.document(product.id)
            try? await FBService.addToFavorites(ref: productsRef, currentUid: currentUid)
        } catch {
            print("Failed to addToFavorites - \(error.localizedDescription)")
        }
    }
    
    func listenToFavoriteProducts(descending: Bool?, completion: @escaping (_ favorites: [FavoriteModel]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let favoritesRef = FBConstants.usersRef.document(currentUid).collection("favorite_products")
        
        let query = descending != nil
            ? favoritesRef.order(by: "min_price", descending: descending!)
            : favoritesRef.order(by: "date_created")
        
        self.favoritesListener = query.addSnapshotListener { snapshot, _ in
            FBService.listenTo(snapshot: snapshot, completion: completion)
        }
    }
}
