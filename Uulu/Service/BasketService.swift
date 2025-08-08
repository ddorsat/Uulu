//
//  BasketService.swift
//  Uulu
//
//  Created by ddorsat on 21.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class BasketService {
    static let shared = BasketService()
    
    private var basketListener: ListenerRegistration? = nil
    
    deinit {
        basketListener = nil
        basketListener?.remove()
    }
    
    func addToBasket(product: ProductModel, capacity: String, variation: ProductVariations) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let documentId = "\(product.id)_\(capacity)"
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket").document(documentId)
        do {
            try await basketRef.setData([
                "product_id": product.id,
                "date_created": Timestamp(),
                "capacity": capacity,
                "price": variation.price,
                "quantity": FieldValue.increment(Int64(1))], merge: true)
        } catch {
            print("Failed to addToBasket - \(error.localizedDescription)")
        }
    }
    
    func removeFromBasket(product: ProductModel, capacity: String) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let documentId = "\(product.id)_\(capacity)"
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket").document(documentId)
            
        do {
            try await basketRef.updateData(["quantity": FieldValue.increment(Int64(-1))])

            let snapshot = try await basketRef.getDocument()
            if let quantity = snapshot.data()?["quantity"] as? Int, quantity <= 0 {
                try await basketRef.delete()
            }
        } catch {
            print("Failed to removeFromBasket - \(error.localizedDescription)")
        }
    }
    
    func listenToQuantity(productId: String, capacity: String, completion: @escaping (Int) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let documentId = "\(productId)_\(capacity)"
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket").document(documentId)
        
        basketRef.addSnapshotListener { snapshot, error in
            guard let snapshot else { return }
            
            let quantity = (snapshot.data()?["quantity"] as? Int) ?? 0
            completion(quantity)
        }
    }
    
    func listenToBasket(completion: @escaping ([BasketModel]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket").order(by: "date_created")
        
        self.basketListener = basketRef.addSnapshotListener { snapshot, _ in
            FBService.listenTo(snapshot: snapshot, completion: completion)
        }
    }
    
    func deleteFromBasket(productId: String, capacity: String) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        let documentId = "\(productId)_\(capacity)"
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket").document(documentId)

        do {
            try await basketRef.delete()
        } catch {
            print("Failed to deleteFromBasket - \(error.localizedDescription)")
        }
    }
    
    func clearBasket(products: [BasketModel]) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket")
        for product in products {
            let productId = "\(product.productId)_\(product.capacity)"
            try? await basketRef.document(productId).delete()
        }
    }
}
