//
//  FavoritesDetailsViewBuilder.swift
//  Uulu
//
//  Created by ddorsat on 08.07.2025.
//

import SwiftUI

struct FavoritesProductDetailsViewBuilder: View {
    @State private var product: ProductModel? = nil
    let favorite: FavoriteModel
    let loggedOutHandler: () -> Void
    
    var body: some View {
        Group {
            if let product {
                ProductDetailsView(product: product) {
                    loggedOutHandler()
                }
            } else {
                ProgressView()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        }
        .task {
            self.product = await ProductsService.shared.fetchProduct(favorite.productID)
        }
    }
}

#Preview {
    FavoritesProductDetailsViewBuilder(favorite: FavoriteModel(productID: "1", dateCreated: Date())) {
        
    }
}
