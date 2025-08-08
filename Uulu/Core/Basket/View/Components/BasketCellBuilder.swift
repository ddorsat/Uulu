//
//  BasketCellBuilder.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import SwiftUI

struct BasketCellBuilder: View {
    @State private var productDetails: ProductModel? = nil
    let productID: String
    let productOrder: BasketModel
    let productQuantity: Int
    let productCapacity: String
    let productPrice: Int
    let onLikeHandler: (ProductModel) -> Void
    let onRemoveHandler: (BasketModel) -> Void
    let onTapHandler: (ProductModel) -> Void
    
    var body: some View {
        Group {
            if let productDetails {
                BasketCell(productDetails: productDetails,
                           productOrder: productOrder,
                           productQuantity: productQuantity,
                           productCapacity: productCapacity,
                           productPrice: productPrice) { product in
                    onLikeHandler(product)
                } onRemoveHandler: { product in
                    onRemoveHandler(product)
                } onTapHandler: { product in
                    onTapHandler(product)
                }
            } else {
                ProgressView()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        }
        .task {
            self.productDetails = await ProductsService.shared.fetchProduct(productID)
        }
    }
}
