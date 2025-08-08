//
//  BrandModel.swift
//  Uulu
//
//  Created by ddorsat on 07.07.2025.
//

import Foundation
import FirebaseAuth

struct BrandModel: Identifiable, Hashable, Codable, BrandCellProtocol {
    let id: String
    let name: String
    let gender: Gender
    let favorites: [String]
    
    var isFavorite: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        return favorites.contains(currentUid)
    }
    
    var isWomen: Bool {
        return gender == .women
    }
    
    var isMen: Bool {
        return gender == .men
    }
    
    var isUnisex: Bool {
        return gender == .unisex
    }
    
    static let placeholder = BrandModel(id: "24", name: Brands.vivienne.rawValue, gender: .men, favorites: [])
}
