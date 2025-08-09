//
//  FavoriteModel.swift
//  Uulu
//
//  Created by ddorsat on 05.07.2025.
//

import Foundation

struct FavoriteModel: Codable, Hashable {
    let productID: String
    let dateCreated: Date
    
    private enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case dateCreated = "date_created"
    }
}
