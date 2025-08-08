//
//  AddToBasketView.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import SwiftUI

struct ProductBasketButton: View {
    @Binding var quantity: Int
    @Binding var selectedVariation: String
    let product: ProductModel
    var maxQuantity: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    private var isSelectedVariationEmpty: Bool {
        product.variations[selectedVariation]?.quantity == 0
    }
    
    var body: some View {
        HStack {
            if isSelectedVariationEmpty {
                ButtonComponents.basketBlackButton(title: "Закончилось", color: Color(.systemGray2))
                    .disabled(selectedVariation.isEmpty)
                
            } else if quantity == 0 || selectedVariation.isEmpty {
                ButtonComponents.basketBlackButton(title: "В корзину", color: .white) {
                    onIncrement()
                }
            } else {
                HStack(spacing: 0) {
                    Button(action: onDecrement) {
                        Image(systemName: "minus")
                            .font(.headline.weight(.bold))
                    }
                    .frame(width: UIScreen.main.bounds.width / 13, height: UIScreen.main.bounds.height / 13)
                    
                    Spacer()
                    
                    Text("\(quantity)")
                        .font(.title3)
                        .minimumScaleFactor(0.8)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: onIncrement) {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(quantity == maxQuantity ? .gray : .white)
                    }
                    .frame(width: UIScreen.main.bounds.width / 13, height: UIScreen.main.bounds.height / 13)
                    .disabled(quantity == maxQuantity)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 14)
                .background(.black)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: quantity)
    }
}

#Preview {
    ProductBasketButton(quantity: .constant(0), selectedVariation: .constant(""), product: .placeholder, maxQuantity: 5) {
        
    } onDecrement: {
        
    }
}
