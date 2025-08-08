//
//  CapacityView.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import SwiftUI

struct ProductCapacityButton: View {
    let capacity: String
    let isSelected: Bool
    let onTapHandler: () -> Void
    
    var body: some View {
        Text(capacity)
            .font(.callout)
            .fontWeight(isSelected ? .bold : .regular)
            .padding(7)
            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.height / 15)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isSelected ? .black : .gray.opacity(0.4), lineWidth: isSelected ? 2 : 1)
            )
            .onTapGesture(perform: onTapHandler)
    }
}

struct ProductCapacityText: View {
    var body: some View {
        Text("ОБЪЕМ / МЛ")
            .font(.callout)
            .fontWeight(.medium)
    }
}

#Preview {
    ProductCapacityButton(capacity: "50", isSelected: false) {
        
    }
}
