//
//  ProductViewBuilder.swift
//  Uulu
//
//  Created by ddorsat on 05.07.2025.
//

import SwiftUI

struct FavoritesProductCellViewBuilder: View {
    @State private var product: ProductModel? = nil
    let productID: String
    let loggedOutHandler: () -> Void
    
    var body: some View {
        Group {
            if let product {
                ProductCellView(product: product, sliding: true) {
                    loggedOutHandler()
                }
            } else {
                ProgressView()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        }
        .task {
            self.product = await ProductsService.shared.fetchProduct(productID)
        }
    }
}


#Preview {
    FavoritesProductCellViewBuilder(productID: "7") {
        
    }
}
