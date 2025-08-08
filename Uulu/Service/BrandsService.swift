//
//  BrandsService.swift
//  Uulu
//
//  Created by ddorsat on 07.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class BrandsService {
    static let shared = BrandsService()
    
    func addBrand(_ brand: BrandModel) async {
        let ref = FBConstants.brandsRef.document(brand.id)
        try? await FBService.upload(ref: ref, model: brand)
    }
    
    func addToFavoriteBrands(_ brand: BrandModel) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let brandsRef = FBConstants.brandsRef.document(brand.id)
        let favoriteBrandsRef = FBConstants.usersRef.document(currentUid).collection("favorite_brands").document(brand.id)
        
        let snapshot = try await favoriteBrandsRef.getDocument()
        if snapshot.exists {
            try await favoriteBrandsRef.delete()
        } else {
            let data: [String: Any] = ["name": brand.name,
                                       "date_created": Timestamp()]
            try await favoriteBrandsRef.setData(data)
        }
        
        try? await FBService.addToFavorites(ref: brandsRef, currentUid: currentUid)
    }
    
    func listenToFavoriteBrands(completion: @escaping (_ brands: [BrandModel]) -> Void) -> ListenerRegistration {
        FBConstants.brandsRef.addSnapshotListener { snapshot, _ in
            FBService.listenTo(snapshot: snapshot, completion: completion)
        }
    }
}
