//
//  FeedViewModel.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import Foundation
import FirebaseFirestore

protocol ProductsViewModelProtocol: ObservableObject {
    var products: [ProductModel] { get set }
    var hasMoreProducts: Bool { get set }
    
    func fetchBySort(_ option: SortOptions) async
    func fetchProducts() async
    func listenToProducts(_ products: [ProductModel])
}

@MainActor
class ProductsViewModel: ObservableObject, @preconcurrency ProductsViewModelProtocol {
    @Published var products: [ProductModel] = []
    @Published var hasMoreProducts: Bool = true
    @Published private(set) var sortOptions: SortOptions? = nil
    
    private var lastDocument: DocumentSnapshot? = nil
    private var productsListener: [ListenerRegistration?] = []
    
    let field: String?
    let isEqualTo: String?
    let isEqualToBool: Bool?
    
    init(field: String? = nil, isEqualTo: String? = nil, isEqualToBool: Bool? = nil) {
        self.field = field
        self.isEqualTo = isEqualTo
        self.isEqualToBool = isEqualToBool
    }
    
    deinit {
        productsListener.forEach { $0?.remove() }
        productsListener.removeAll()
    }
    
    func fetchBySort(_ option: SortOptions) async {
        self.sortOptions = option
        self.products = []
        self.lastDocument = nil
        self.hasMoreProducts = true
        
        await fetchProducts()
    }
    
    func fetchProducts() async {
        guard hasMoreProducts else { return }
        
        if let (newProducts, lastDocument) =
            try? await ProductsService.shared.fetchProducts(descending: sortOptions?.descending,
                                                            count: 6,
                                                            field: field,
                                                            isEqualTo: isEqualTo,
                                                            isEqualToBool: isEqualToBool,
                                                            searchText: nil,
                                                            lastDocument: lastDocument) {
            if newProducts.isEmpty {
                hasMoreProducts = false
            }
            if let lastDocument {
                self.lastDocument = lastDocument
            }
            
            self.products.append(contentsOf: newProducts)
            listenToProducts(newProducts)
        }
    }
    
    func listenToProducts(_ products: [ProductModel]) {
        for product in products {
            let listener = ProductsService.shared.listenToProduct(id: product.id) { [weak self] updatedProduct in
                guard let self else { return }
                
                if let index = self.products.firstIndex(where: { $0.id == updatedProduct.id }) {
                    self.products[index] = updatedProduct
                }
            }
            self.productsListener.append(listener)
        }
    }
}

enum SortOptions: String, CaseIterable {
    case none = "По умолчанию"
    case higherPrice = "По возрастанию цены"
    case lowerPrice = "По убыванию цены"
    
    var descending: Bool? {
        switch self {
            case .none:
                return nil
            case .higherPrice:
                return false
            case .lowerPrice:
                return true
        }
    }
}
