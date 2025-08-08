//
//  CatalogView.swift
//  Uulu
//
//  Created by ddorsat on 02.07.2025.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @Binding var selectedTab: Tabs
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var body: some View {
        NavigationStack(path: $viewModel.catalogRoute) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.products) { product in
                        Button {
                            viewModel.catalogRoute.append(.productDetails(product))
                        } label: {
                            ProductCellView(product: product, sliding: true) {
                                selectedTab = .profile
                            }
                        }
                        .onAppear {
                            if product == viewModel.products.last && viewModel.hasMoreProducts {
                                Task { await viewModel.fetchProducts() }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
            .scrollIndicators(.hidden)
            .navigationTitle("Каталог")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: CatalogRoute.self) { destination in
                destinationView(route: destination)
            }
            .toolbar {
                navLeadingButton()
                navTrailingButton()
            }
        }
    }
}

extension CatalogView {
    @ToolbarContentBuilder
    private func navLeadingButton() -> some ToolbarContent {
        MenuComponents.makeMenu(SortOptions.self) { option in
            Task { await viewModel.fetchBySort(option) }
        }
    }
    
    @ToolbarContentBuilder
    private func navTrailingButton() -> some ToolbarContent {
        ButtonComponents.basketButton {
            viewModel.catalogRoute.append(.basket)
        }
    }
    
    @ViewBuilder
    private func destinationView(route: CatalogRoute) -> some View {
        switch route {
            case .productDetails(let product):
                ProductDetailsView(product: product) {
                    selectedTab = .profile
                }
            case .basket:
                BasketView(viewModel: viewModel.basketViewModel) { product in
                    viewModel.catalogRoute.append(.productDetails(product))
                } onSearchRoute: {
                    selectedTab = .search
                } onCatalogRoute: {
                    viewModel.catalogRoute.removeAll()
                    selectedTab = .catalog
                } orderButton: {
                    viewModel.catalogRoute.append(.basketOrder)
                }
            case .basketOrder:
                BasketOrderView(viewModel: viewModel.basketViewModel) {
                    viewModel.catalogRoute.append(.basketOrderComplete)
                }
            case .basketOrderComplete:
                BasketOrderCompleteView() {
                    viewModel.catalogRoute.removeAll()
                } backButtonHandler: {
                    viewModel.catalogRoute.removeAll()
                }
        }
    }
}


#Preview {
    CatalogView(selectedTab: .constant(.catalog))
}
