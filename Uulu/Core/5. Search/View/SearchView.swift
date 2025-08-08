//
//  SearchView.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Binding var selectedTab: Tabs
    
    var body: some View {
        NavigationStack(path: $viewModel.searchRoutes) {
            ScrollView {
                VStack(alignment: .leading, spacing: 70) {
                    searchBar()
                    
                    VStack(alignment: .leading, spacing: 30) {
                        SearchCell(search: .catalog) {
                            viewModel.searchRoutes.append(.catalogOptions)
                        }
                        
                        SearchCell(search: .novelty) {
                            viewModel.searchRoutes.append(.novelty)
                        }
                        
                        SearchCell(search: .brands) {
                            viewModel.searchRoutes.append(.brands)
                        }
                        
                        SearchCell(search: .trending) {
                            viewModel.searchRoutes.append(.trending)
                        }
                        
                        SearchCell(search: .profile) {
                            selectedTab = .profile
                        }
                    }
                }
                .padding(.horizontal, 20)
                .navigationDestination(for: SearchRoutes.self) { destination in
                    destinationView(route: destination)
                }
                .toolbar {
                    ButtonComponents.basketButton {
                        viewModel.searchRoutes.append(.basket)
                    }
                }
            }
        }
    }
}

extension SearchView {
    private func searchBar() -> some View {
        VStack {
            TextField("Поиск", text: $viewModel.searchText)
                .foregroundStyle(.black)
                .font(.system(size: 40))
                .minimumScaleFactor(0.8)
                .fontWeight(.semibold)
                .overlay(alignment: .trailing) {
                    if !viewModel.searchText.isEmpty {
                        Button {
                            Task { await viewModel.startSearch() }
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black)
                                .imageScale(.medium)
                                .fontWeight(.semibold)
                                .padding(11)
                                .background(.ultraThinMaterial)
                                .opacity(0.7)
                                .clipShape(Circle())
                        }
                    }
                }
            
            Divider()
                .padding(.top, -5)
        }
    }
    
    @ViewBuilder
    private func destinationView(route: SearchRoutes) -> some View {
        switch route {
            case .catalogOptions:
                CatalogOptionsView(route: $viewModel.searchRoutes) { option in
                    viewModel.searchRoutes.append(.catalogProducts(option))
                }
            case .catalogProducts(let productType):
                ProductsView(viewModel: getProductsViewModel(field: "product_type",
                                                             value: productType.rawValue),
                             title: productType.rawValue) { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.searchRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .novelty:
                ProductsView(viewModel: viewModel.noveltyViewModel,
                             title: "Новинки") { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.searchRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .brands:
                BrandsView(viewModel: viewModel.brandsViewModel,
                           searchRoutes: $viewModel.searchRoutes) {
                    selectedTab = .profile
                }
            case .brandProducts(let brand):
                ProductsView(viewModel: getProductsViewModel(field: "brand",
                                                             value: brand.name),
                             title: brand.name) { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.searchRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .trending:
                ProductsView(viewModel: viewModel.trendingViewModel,
                             title: "В тренде") { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.searchRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .searchResults:
                ProductsView(viewModel: viewModel,
                             title: "Поиск") { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.searchRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .productDetails(let product):
                ProductDetailsView(product: product) {
                    selectedTab = .profile
                }
            case .basket:
                BasketView(viewModel: viewModel.basketViewModel) { product in
                    viewModel.searchRoutes.append(.productDetails(product))
                } onSearchRoute: {
                    viewModel.searchRoutes.removeAll()
                    selectedTab = .search
                } onCatalogRoute: {
                    selectedTab = .catalog
                } orderButton: {
                    viewModel.searchRoutes.append(.basketOrder)
                }
            case .basketOrder:
                BasketOrderView(viewModel: viewModel.basketViewModel) {
                    viewModel.searchRoutes.append(.basketOrderComplete)
                }
            case .basketOrderComplete:
                BasketOrderCompleteView() {
                    selectedTab = .catalog
                } backButtonHandler: {
                    viewModel.searchRoutes.removeAll()
                }
        }
    }
    
    private func getProductsViewModel<T: Hashable>(field: String, value: T) -> ProductsViewModel {
        let key = String(describing: value)
        
        if let viewModel = viewModel.productsViewModels[key] {
            return viewModel
        } else {
            let productsViewModel = ProductsViewModel(field: field, isEqualTo: key)
            viewModel.productsViewModels[key] = productsViewModel
            Task { await productsViewModel.fetchProducts() }
            return productsViewModel
        }
    }
}


#Preview {
    SearchView(selectedTab: .constant(.feed))
}
