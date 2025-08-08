//
//  ProductsView.swift
//  Uulu
//
//  Created by ddorsat on 11.07.2025.
//

import SwiftUI
import FirebaseFirestore

struct ProductsView<VM: ProductsViewModelProtocol>: View {
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    @ObservedObject var viewModel: VM
    let title: String
    let onTapHandler: (ProductModel) -> Void
    let basketHandler: () -> Void
    let loggedOutHandler: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.products) { product in
                    Button {
                        onTapHandler(product)
                    } label: {
                        ProductCellView(product: product, sliding: true) {
                            loggedOutHandler()
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .toolbar {
            MenuComponents.makeMenu(SortOptions.self) { option in
                Task { await viewModel.fetchBySort(option) }
            }
            
            ButtonComponents.basketButton {
                basketHandler()
            }
        }
    }
}

