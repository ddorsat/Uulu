//
//  SearchCell.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import SwiftUI

struct SearchCell: View {
    let search: Searches
    let onTapHandler: () -> Void
    
    var body: some View {
        Text(search.rawValue)
            .font(.system(size: 33))
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .onTapGesture {
                onTapHandler()
            }
    }
}

enum Searches: String {
    case catalog = "Каталог"
    case novelty = "Новинки"
    case brands = "Бренды"
    case trending = "В тренде"
    case profile = "Профиль"
}

#Preview {
    SearchCell(search: .catalog) {
        
    }
}
