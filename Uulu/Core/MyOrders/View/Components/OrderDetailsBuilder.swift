//
//  OrderDetailsBuilder.swift
//  Uulu
//
//  Created by ddorsat on 21.07.2025.
//

import SwiftUI

struct OrderDetailsBuilder: View {
    @State private var product: ProductModel? = nil
    let productId: String
    let productQuantity: Int
    let productPrice: Int
    let productCapacity: String
    let productDetailsHandler: (ProductModel) -> Void
    
    var body: some View {
        Group {
            if let product {
                OrderDetailsCell(product: product,
                                 productQuantity: productQuantity,
                                 productPrice: productPrice,
                                 productCapacity: productCapacity) { product in
                    productDetailsHandler(product)
                }
            } else {
                ProgressView()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        }
        .task {
            self.product = await ProductsService.shared.fetchProduct(productId)
        }
    }
}

#Preview {
    OrderDetailsBuilder(productId: "1", productQuantity: 3, productPrice: 123, productCapacity: "123") { _ in
        
    }
}
