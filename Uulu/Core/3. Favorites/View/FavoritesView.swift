//
//  FavoritesView.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @Binding var selectedTab: Tabs
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack(path: $viewModel.favoritesRoutes) {
            VStack {
                if viewModel.favorites.isEmpty {
                    EmptyViewComponent.emptyView(
                        title: "Здесь пока пусто",
                        description: "Добавляйте товары в любимое, чтобы они всегда были под рукой.",
                        buttonTitle: "В каталог") {
                        selectedTab = .catalog
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.favorites, id: \.self) { favorite in
                                Button {
                                    viewModel.favoritesRoutes.append(.favoriteProductDetails(favorite))
                                } label: {
                                    FavoritesProductCellViewBuilder(productID: favorite.productID) {
                                        selectedTab = .profile
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
                    }
                }
            }
            .navigationDestination(for: FavoritesRoutes.self) { destination in
                destinationView(route: destination)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Любимое")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                MenuComponents.makeMenu(SortOptions.self) { option in
                    viewModel.fetchBySort(option)
                }
                
                ButtonComponents.basketButton {
                    viewModel.favoritesRoutes.append(.basket)
                }
            }
        }
    }
}

extension FavoritesView {
    @ViewBuilder
    private func destinationView(route: FavoritesRoutes) -> some View {
        switch route {
            case .favoriteProductDetails(let favorite):
                FavoritesProductDetailsViewBuilder(favorite: favorite) {
                    selectedTab = .profile
                }
            case .basket:
                BasketView(viewModel: viewModel.basketViewModel) { product in
                    viewModel.favoritesRoutes.append(.basketProductDetails(product))
                } onSearchRoute: {
                    selectedTab = .search
                } onCatalogRoute: {
                    selectedTab = .catalog
                } orderButton: {
                    viewModel.favoritesRoutes.append(.basketOrder)
                }
            case .basketProductDetails(let product):
                ProductDetailsView(product: product) {
                    selectedTab = .profile
                }
            case .basketOrder:
                BasketOrderView(viewModel: viewModel.basketViewModel) {
                    viewModel.favoritesRoutes.append(.basketOrderComplete)
                }
            case .basketOrderComplete:
                BasketOrderCompleteView() {
                    selectedTab = .catalog
                } backButtonHandler: {
                    viewModel.favoritesRoutes.removeAll()
                }
        }
    }
}

#Preview {
    FavoritesView(selectedTab: .constant(.favorites))
}
