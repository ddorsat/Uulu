//
//  BrandsViewModel.swift
//  Uulu
//
//  Created by ddorsat on 07.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class BrandsViewModel: ProductsViewModel {
    @Published private(set) var brands: [BrandModel] = []
    
    private var favoriteBrandsListener: ListenerRegistration? = nil
    
    init() {
        super.init()
        
        listenToFavoriteBrands()
    }
    
    deinit {
        favoriteBrandsListener = nil
        favoriteBrandsListener?.remove()
    }
    
    func addToFavorites(_ brand: BrandModel) async {
        try? await BrandsService.shared.addToFavoriteBrands(brand)
    }
    
    private func listenToFavoriteBrands() {
        self.favoriteBrandsListener = BrandsService.shared.listenToFavoriteBrands { [weak self] brands in
            self?.brands = brands
        }
    }
}

