//
//  BrandsSearchCell.swift
//  Uulu
//
//  Created by ddorsat on 07.07.2025.
//

import SwiftUI
import FirebaseAuth

protocol BrandCellProtocol: Hashable {
    var name: String { get }
    var isFavorite: Bool { get }
}

struct BrandsCell<T: BrandCellProtocol>: View {
    let brand: T
    let onTapHandler: () -> Void
    let addToFavoriteBrands: () -> Void
    let loggedOutHandler: () -> Void
    
    var body: some View {
        Text(brand.name)
            .font(.title3)
            .minimumScaleFactor(0.8)
            .fontWeight(.medium)
            .padding(.vertical, 20)
            .padding(.leading, 59)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6).opacity(0.8))
        
            .onTapGesture {
                onTapHandler()
            }
        
            .overlay(alignment: .leading) {
                Image(systemName: brand.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 23))
                    .foregroundStyle(brand.isFavorite ? .red : .black)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .background {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .contentShape(Rectangle())
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                if Auth.auth().currentUser != nil {
                                    addToFavoriteBrands()
                                } else {
                                    loggedOutHandler()
                                }
                            }
                    }
            }
    }
}
