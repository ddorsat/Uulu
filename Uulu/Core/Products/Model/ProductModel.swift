//
//  ProductModel.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import Foundation
import FirebaseAuth

struct ProductModel: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let brand: Brands
    let productType: Descriptions.ProductType
    let gender: Descriptions.Gender
    let use: Descriptions.Use
    let category: Descriptions.Category
    let description: String
    let fullDescription: String
    let available: Bool
    let images: [String]
    let favorites: [String]
    let isNovelty: Bool
    let isTrending: Bool
    let minPrice: Int
    let variations: [String: ProductVariations]
    
    var isFavorite: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        return favorites.contains(currentUid)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case productType = "product_type"
        case gender
        case use
        case category
        case description
        case fullDescription = "full_description"
        case available
        case images
        case favorites
        case isNovelty = "is_novelty"
        case isTrending = "is_trending"
        case minPrice = "min_price"
        case variations
    }
    
    static let placeholder = ProductModel(
        id: "53",
        name: "Bvlgari Allegra Ma'Magnifica",
        brand: .bvlgari,
        productType: .perfumeWater,
        gender: .woman,
        use: .body,
        category: .makeup,
        description: "Парфюмерная вода",
        fullDescription: "Парфюмерная вода MA'MAGNIFICA — дань красоте и манящей ауре итальянских женщин. Величественный цветочно-древесный аромат выстраивается вокруг главных нот розы и сандала. Усилить звучание композиции и создать индивидуальное сочетание под свое настроение можно с помощью одной из эссенций коллекции Bvlgari Allegra, идеально дополняющих гармонию нот.",
        available: true,
        images: ["bvlgari-2-1", "bvlgari-2-2", "bvlgari-2-3"],
        favorites: [],
        isNovelty: false,
        isTrending: false,
        minPrice: 10900,
        variations: ["50": ProductVariations(price: 10900, quantity: 3), "100": ProductVariations(price: 10500, quantity: 3)]
    )
}

struct ProductVariations: Hashable, Codable {
    let price: Int
    let quantity: Int
}
