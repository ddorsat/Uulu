//
//  ProductOrderModel.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import Foundation

struct BasketModel: Hashable, Codable {
    let productId: String
    let dateCreated: Date? = Date()
    let capacity: String
    let price: Int
    let quantity: Int?
    
    var productQuantity: Int {
        return quantity ?? 0
    }
    
    var productPrice: Int {
        return price * (quantity ?? 1)
    }
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case dateCreated = "date_created"
        case price
        case capacity
        case quantity
    }
}
