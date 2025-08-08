//
//  ProductDetailsPrice.swift
//  Uulu
//
//  Created by ddorsat on 19.07.2025.
//

import SwiftUI

struct ProductPrice: View {
    let capacity: Int
    let isSelected: Bool
    
    var body: some View {
        Text("\(capacity)")
            .font(.title)
            .minimumScaleFactor(0.8)
            .fontWeight(.semibold)
    }
}

#Preview {
    ProductPrice(capacity: 0, isSelected: false)
}
