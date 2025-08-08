//
//  SearchCatalogOptionsView.swift
//  Uulu
//
//  Created by ddorsat on 12.07.2025.
//

import SwiftUI

struct CatalogOptionsView: View {
    @Binding var route: [SearchRoutes]
    let onTapHandler: (Descriptions.ProductType) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(Descriptions.ProductType.allCases, id: \.self) { option in
                    CatalogCell(title: option.rawValue) {
                        onTapHandler(option)
                    }
                }
            }
            .padding([.horizontal, .top])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .navigationTitle("Каталог")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        CatalogOptionsView(route: .constant([.productDetails(.placeholder)])) { _ in 
            
        }
    }
}
