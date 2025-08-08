//
//  FeedRepresentable.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @Binding var selectedTab: Tabs
    let rows = [GridItem(.flexible())]
    
    var body: some View {
        NavigationStack(path: $viewModel.feedRoutes) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FeedVideo() {
                        viewModel.feedRoutes.append(.video)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        title("Новинки") {
                            viewModel.feedRoutes.append(.novelty)
                        }
                        
                        scrollView(products: viewModel.noveltyViewModel.products) { product in
                            viewModel.feedRoutes.append(.productDetails(product))
                        } exploreRoute: {
                            viewModel.feedRoutes.append(.novelty)
                        }
                    }
                    
                    FeedPhoto() {
                        viewModel.feedRoutes.append(.perfumes)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        title("В тренде") {
                            viewModel.feedRoutes.append(.trending)
                        }
                        
                        scrollView(products: viewModel.trendingViewModel.products) { product in
                            viewModel.feedRoutes.append(.productDetails(product))
                        } exploreRoute: {
                            viewModel.feedRoutes.append(.trending)
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchAllData()
            }
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FeedRoutes.self) { destination in
                destinationView(route: destination)
            }
            .toolbar {
                navTitle()
                
                ButtonComponents.basketButton {
                    viewModel.feedRoutes.append(.basket)
                }
            }
        }
    }
}

extension FeedView {
    private func navTitle() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("UULU")
                .font(.system(size: 30))
                .minimumScaleFactor(0.8)
                .fontWeight(.bold)
        }
    }
    
    private func title(_ text: String, completion: @escaping () -> Void) -> some View {
        HStack(alignment: .center, spacing: 13) {
            Text(text)
                .font(.system(size: 32))
                .minimumScaleFactor(0.8)
                .fontWeight(.semibold)
            
            Rectangle()
                .frame(width: 23, height: 2)
        }
        .padding(.horizontal, 10)
        .onTapGesture {
            completion()
        }
    }
    
    private func scrollView(products: [ProductModel],
                            detailsRoute: @escaping (ProductModel) -> Void,
                            exploreRoute: @escaping () -> Void) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 30) {
                ForEach(products.prefix(6)) { product in
                    Button {
                        detailsRoute(product)
                    } label: {
                        ProductCellView(product: product, sliding: false) {
                            selectedTab = .profile
                        }
                    }
                }
                FeedExploreMore {
                    exploreRoute()
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func destinationView(route: FeedRoutes) -> some View {
        switch route {
            case .video:
                ProductsView(viewModel: viewModel.videoViewModel,
                             title: "David Beckham") { product in
                    viewModel.feedRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.feedRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .perfumes:
                ProductsView(viewModel: viewModel.perfumesViewModel,
                             title: "Парфюмерия") { product in
                    viewModel.feedRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.feedRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .novelty:
                ProductsView(viewModel: viewModel.noveltyViewModel,
                             title: "Новинки") { product in
                    viewModel.feedRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.feedRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .trending:
                ProductsView(viewModel: viewModel.trendingViewModel,
                             title: "В тренде") { product in
                    viewModel.feedRoutes.append(.productDetails(product))
                } basketHandler: {
                    viewModel.feedRoutes.append(.basket)
                } loggedOutHandler: {
                    selectedTab = .profile
                }
            case .productDetails(let product):
                ProductDetailsView(product: product) {
                    selectedTab = .profile
                }
            case .basket:
                BasketView(viewModel: viewModel.basketViewModel) { product in
                    viewModel.feedRoutes.append(.productDetails(product))
                } onSearchRoute: {
                    selectedTab = .search
                } onCatalogRoute: {
                    selectedTab = .catalog
                } orderButton: {
                    viewModel.feedRoutes.append(.basketOrder)
                }
            case .basketOrder:
                BasketOrderView(viewModel: viewModel.basketViewModel) {
                    viewModel.feedRoutes.append(.basketOrderComplete)
            }
            case .basketOrderComplete:
                BasketOrderCompleteView() {
                    selectedTab = .catalog
                } backButtonHandler: {
                    viewModel.feedRoutes.removeAll()
                }
        }
    }
}


#Preview {
    FeedView(selectedTab: .constant(.feed))
}
