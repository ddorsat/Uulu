//
//  CatalogViewModel.swift
//  Uulu
//
//  Created by ddorsat on 02.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class CatalogViewModel: ProductsViewModel {
    @Published var basketViewModel = BasketViewModel()
    @Published var catalogRoute: [CatalogRoute] = []
    
    init() {
        super.init()
        
        Task { await fetchProducts() }
        basketViewModel.listenToBasket()
    }
}

enum CatalogRoute: Hashable {
    case productDetails(_ product: ProductModel)
    case basket
    case basketOrder
    case basketOrderComplete
}
