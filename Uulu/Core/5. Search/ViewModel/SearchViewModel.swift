//
//  SearchViewModel.swift
//  Uulu
//
//  Created by ddorsat on 02.07.2025.
//

import Foundation
import FirebaseFirestore

@MainActor
final class SearchViewModel: ObservableObject, @preconcurrency ProductsViewModelProtocol {
    @Published private(set) var brandsViewModel = BrandsViewModel()
    @Published private(set) var noveltyViewModel = NoveltyViewModel()
    @Published private(set) var trendingViewModel = TrendingViewModel()
    @Published private(set) var basketViewModel = BasketViewModel()
    @Published var searchText = ""
    @Published var products: [ProductModel] = []
    @Published var searchRoutes: [SearchRoutes] = []
    @Published var hasMoreProducts: Bool = true
    @Published private(set) var sortOptions: SortOptions? = nil
    
    private var lastDocument: DocumentSnapshot? = nil
    private var productsListener: [ListenerRegistration?] = []
    var productsViewModels: [String: ProductsViewModel] = [:]
    
    init() {
        Task { await fetchAllData() }
    }
    
    deinit {
        productsListener.forEach { $0?.remove() }
        productsListener.removeAll()
    }
    
    func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.noveltyViewModel.fetchProducts()
            }
            
            group.addTask {
                await self.trendingViewModel.fetchProducts()
            }
            
            group.addTask {
                await self.basketViewModel.listenToBasket()
            }
            
            group.addTask {
                await self.brandsViewModel.fetchProducts()
            }
        }
    }
    
    func startSearch() async {
        resetSearch()
        
        await fetchProducts()
        self.searchRoutes.append(.searchResults)
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
        
        if let (newProducts, lastDocument) = try? await ProductsService.shared.fetchProducts(descending: sortOptions?.descending, count: 6, field: nil, isEqualTo: nil, isEqualToBool: nil, searchText: searchText, lastDocument: lastDocument) {
            if newProducts.isEmpty {
                self.hasMoreProducts = false
                return
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
    
    private func resetSearch() {
        self.products = []
        self.lastDocument = nil
        self.hasMoreProducts = true
    }
}

enum SearchRoutes: Hashable {
    case catalogOptions
    case catalogProducts(_ option: Descriptions.ProductType)
    case novelty
    case brands
    case brandProducts(_ brand: BrandModel)
    case trending
    case searchResults
    case productDetails(_ product: ProductModel)
    case basket
    case basketOrder
    case basketOrderComplete
}
