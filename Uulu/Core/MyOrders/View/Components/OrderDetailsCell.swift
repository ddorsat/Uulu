//
//  OrderDetailsCell.swift
//  Uulu
//
//  Created by ddorsat on 21.07.2025.
//

import SwiftUI

struct OrderDetailsCell: View {
    let product: ProductModel
    let productQuantity: Int
    let productPrice: Int
    let productCapacity: String
    let productDetailsHandler: (ProductModel) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(product.images.first ?? "")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: .infinity)
                .frame(maxWidth: UIScreen.main.bounds.width / 4)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text("\(productCapacity) мл.")
                
                Spacer()
                
                Text("\(productPrice) ₽")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 18))
            .fontWeight(.light)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("\(productQuantity) шт.")
                .fontWeight(.medium)
        }
        .frame(height: UIScreen.main.bounds.height / 10)
        .onTapGesture {
            productDetailsHandler(product)
        }
    }
}

#Preview {
    OrderDetailsCell(product: .placeholder, productQuantity: 2, productPrice: 1231, productCapacity: "50") { _ in
        
    }
}
