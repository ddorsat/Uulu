//
//  FavoritesViewModel.swift
//  Uulu
//
//  Created by ddorsat on 04.07.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var basketViewModel = BasketViewModel()
    @Published private(set) var favorites: [FavoriteModel] = []
    @Published var favoritesRoutes: [FavoritesRoutes] = []
    @Published private(set) var sortOptions: SortOptions? = nil
    
    private var hasAppeared: Bool = false
    
    init() {
        listenToFavorites(descending: sortOptions?.descending)
        
        basketViewModel.listenToBasket()
    }
    
    func fetchBySort(_ option: SortOptions) {
        self.sortOptions = option
        self.favorites = []
        
        listenToFavorites(descending: sortOptions?.descending)
    }
    
    func listenToFavorites(descending: Bool?) {
        FavoritesService.shared.listenToFavoriteProducts(descending: descending) { [weak self] favorites in
            self?.favorites = favorites
        }
    }
}

enum FavoritesRoutes: Hashable {
    case favoriteProductDetails(_ favorite: FavoriteModel)
    case basket
    case basketProductDetails(_ product: ProductModel)
    case basketOrder
    case basketOrderComplete
}


