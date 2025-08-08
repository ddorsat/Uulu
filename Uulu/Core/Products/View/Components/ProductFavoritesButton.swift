//
//  AddToFavoritesView.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import SwiftUI

struct ProductFavoritesButton: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    let onTapHandler: () -> Void
    
    var body: some View {
        Button {
            onTapHandler()
        } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isFavorite ? .red : .white)
                .font(.title)
                .minimumScaleFactor(0.8)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 14)
                .background(.black)
        }
    }
}

#Preview {
    ProductFavoritesButton(viewModel: ProductDetailsViewModel(product: .placeholder)) {
        
    }
}
