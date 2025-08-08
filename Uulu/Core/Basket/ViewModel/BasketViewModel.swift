//
//  BasketViewModel.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import Foundation
import FirebaseFirestore
import AlertKit

final class BasketViewModel: ObservableObject {
    @Published var products: [BasketModel] = [] {
        didSet {
            totalSum = productsTotalSum
            
            if promocodeApplied {
                promocodeApplied = false
                promocode = ""
            }
        }
    }
    @Published var address: String = ""
    @Published var houseNumber: String = ""
    @Published var apartment: String = ""
    @Published var promocode: String = ""
    @Published var promocodeApplied: Bool = false
    @Published var totalSum: Int = 0
    @Published var productToDelete: BasketModel? = nil
    @Published var showDeleteProduct: Bool = false
    @Published var showClearAll: Bool = false
    @Published var invalidPromocode: Bool = false
    @Published var validPromocode: Bool = false
    
    var invalidPromocodeAlert = AlertAppleMusic17View(title: "Неверный промокод", icon: .error)
    var validPromocodeAlert = AlertAppleMusic17View(title: "Промокод применен", icon: .done)
    
    var basketIsEmpty: Bool {
        products.isEmpty
    }
    
    var productsTotalSum: Int {
        products.reduce(0) { $0 + $1.productPrice }
    }
    
    var totalCount: Int {
        products.reduce(0) { $0 + ($1.quantity ?? 0)}
    }
    
    func applyPromocode() {
        if promocode.uppercased() == "LETO21" {
            promocodeApplied = true
            validPromocode = true
            totalSum = Int(Double(productsTotalSum) * 0.79)
        } else {
            promocodeApplied = false
            invalidPromocode = true
            totalSum = productsTotalSum
        }
    }
    
    private var ordererFullAddress: String {
        var parts: [String] = []
        
        let addressWithHouseNumber: String = address + " " + houseNumber
        parts.append(addressWithHouseNumber)
        
        if !apartment.isEmpty {
            parts.append("кв. \(apartment)")
        }
        
        return parts.joined(separator: ", ")
    }
    
    func listenToBasket() {
        BasketService.shared.listenToBasket { [weak self] products in
            self?.products = products
        }
    }
    
    func addToFavorites(_ product: ProductModel) async {
        await FavoritesService.shared.addToFavoriteProducts(product: product)
    }
    
    func deleteFromBasket(_ product: BasketModel) async {
        showDeleteProduct = false
        await BasketService.shared.deleteFromBasket(productId: product.productId, capacity: product.capacity)
    }
    
    func orderFromBasket() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await OrdersService.shared.makeOrder(products: products,
                                             address: ordererFullAddress,
                                             totalSum: totalSum,
                                             promocodeApplied: promocodeApplied)
    }
    
    func clearBasket() async {
        showClearAll = false
        await BasketService.shared.clearBasket(products: products)
    }
}
