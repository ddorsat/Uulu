//
//  UnisexSearchView.swift
//  Uulu
//
//  Created by ddorsat on 07.07.2025.
//

import SwiftUI

struct UnisexBrands: View {
    @ObservedObject var viewModel: BrandsViewModel
    @Binding var searchRoutes: [SearchRoutes]
    let loggedOutHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.brands) { brand in
                if brand.isUnisex {
                    BrandsCell(brand: brand) {
                        searchRoutes.append(.brandProducts(brand))
                    } addToFavoriteBrands: {
                        Task { await viewModel.addToFavorites(brand) }
                    } loggedOutHandler: {
                        loggedOutHandler()
                    }
                }
            }
        }
    }
}

#Preview {
    UnisexBrands(viewModel: BrandsViewModel(), searchRoutes: .constant([.productDetails(.placeholder)])) {
        
    }
}
