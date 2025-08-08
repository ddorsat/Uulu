//
//  ProductDetailsViewModel.swift
//  Uulu
//
//  Created by ddorsat on 10.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    @Published private(set) var product: ProductModel
    @Published var quantityInBasket: Int = 0
    
    private var favoritesListener: ListenerRegistration? = nil
    private var basketListener: ListenerRegistration? = nil
    
    deinit {
        favoritesListener?.remove()
        basketListener?.remove()
    }
    
    init(product: ProductModel) {
        self.product = product
        listenToFavorites(product)
    }
    
    var isFavorite: Bool {
        product.isFavorite
    }
    
    var productIsEmpty: Bool {
        product.variations.values.allSatisfy { $0.quantity == 0 }
    }
    
    func addToFavorites(_ product: ProductModel) async {
        await FavoritesService.shared.addToFavoriteProducts(product: product)
    }
    
    private func listenToFavorites(_ product: ProductModel) {
        self.favoritesListener = ProductsService.shared.listenToProduct(id: product.id) { [weak self] updatedProduct in
            self?.product = updatedProduct
        }
    }
    
    func addToBasket(capacity: String, variation: ProductVariations) async {
        await BasketService.shared.addToBasket(product: product, capacity: capacity, variation: variation)
    }
    
    func removeFromBasket(capacity: String) async {
        await BasketService.shared.removeFromBasket(product: product, capacity: capacity)
    }
    
    func listenToQuantity(capacity: String) {
        BasketService.shared.listenToQuantity(productId: product.id, capacity: capacity) { [weak self] quantity in
            DispatchQueue.main.async {
                self?.quantityInBasket = quantity
            }
        }
    }
}
