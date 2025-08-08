//
//  CatalogCell.swift
//  Uulu
//
//  Created by ddorsat on 12.07.2025.
//

import SwiftUI

struct CatalogCell: View {
    let title: String
    let onTapHandler: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .fontWeight(.semibold)
                .layoutPriority(1)
            
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            
            Image(systemName: "chevron.right")
        }
        .font(.system(size: 22))
        .minimumScaleFactor(0.8)
        .frame(height: UIScreen.main.bounds.height / 16)
        .onTapGesture {
            onTapHandler()
        }
    }
}

#Preview {
    CatalogCell(title: "Помада") {
        
    }
}
