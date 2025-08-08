//
//  BasketCell.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import SwiftUI

struct BasketCell: View {
    @StateObject var productDetailsViewModel: ProductDetailsViewModel
    let productOrder: BasketModel
    let productQuantity: Int
    let productCapacity: String
    let productPrice: Int
    let onLikeHandler: (ProductModel) -> Void
    let onRemoveHandler: (BasketModel) -> Void
    let onTapHandler: (ProductModel) -> Void
    
    private var productDetails: ProductModel { productDetailsViewModel.product }
    
    init(productDetails: ProductModel,
         productOrder: BasketModel,
         productQuantity: Int,
         productCapacity: String,
         productPrice: Int,
         onLikeHandler: @escaping (ProductModel) -> Void,
         onRemoveHandler: @escaping (BasketModel) -> Void,
         onTapHandler: @escaping (ProductModel) -> Void) {
        self._productDetailsViewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: productDetails))
        self.productOrder = productOrder
        self.productQuantity = productQuantity
        self.productCapacity = productCapacity
        self.productPrice = productPrice
        self.onLikeHandler = onLikeHandler
        self.onRemoveHandler = onRemoveHandler
        self.onTapHandler = onTapHandler
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .top) {
                Image(productDetails.images.first ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width / 4)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(productDetails.description)
                        .lineLimit(1)
                        .fontWeight(.light)
                    
                    Text(productDetails.name)
                        .font(.title3)
                        .lineLimit(2)
                        .fontWeight(.medium)
                }
            }
            .frame(height: UIScreen.main.bounds.height / 10)
            
            HStack(alignment: .center) {
                HStack(spacing: 22) {
                    Button {
                        onLikeHandler(productDetails)
                    } label: {
                        Image(systemName: productDetails.isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .background(Color(.systemGray6))
                            .frame(maxHeight: .infinity)
                    }
                    
                    Button {
                        onRemoveHandler(productOrder)
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .padding(9)
                            .background(Color(.systemGray6))
                            .frame(maxHeight: .infinity)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 4)
                
                HStack(spacing: 5) {
                    Text(productCapacity)
                    
                    Text("мл")
                    
                    Text("/")
                    
                    Text("\(productQuantity)")
                    
                    Text("шт.")
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                
                Spacer()
                
                Text("\(productPrice) ₽")
                    .font(.title2)
                    .minimumScaleFactor(0.8)
                    .fontWeight(.medium)
                    .frame(maxHeight: .infinity)
            }
            .frame(height: UIScreen.main.bounds.height / 22)
        }
        .frame(height: UIScreen.main.bounds.height / 6)
        .onTapGesture {
            onTapHandler(productDetails)
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    BasketCell(productDetails: .placeholder, productOrder: BasketModel(productId: "1", capacity: "2", price: 5, quantity: 2), productQuantity: 5, productCapacity: "1", productPrice: 109) { _ in
        
    } onRemoveHandler: { _ in
        
    } onTapHandler: { _ in
        
    }

}
