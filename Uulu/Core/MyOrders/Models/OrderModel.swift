//
//  OrderModel.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import Foundation
import FirebaseCore

struct OrderModel: Hashable, Codable {
    let uid: String
    let products: [String: OrderProductsModel]
    let status: OrderStatus
    let dateCreated: Date
    let address: String
    let userId: String
    let totalSum: Int
    let productsSum: Int
    let promocodeApplied: Bool
    
    var productsSorted: [Dictionary<String, OrderProductsModel>.Values.Element] {
        products.values.sorted(by: { $0.dateCreated < $1.dateCreated })
    }
    
    private enum CodingKeys: String, CodingKey {
        case uid
        case products
        case status
        case dateCreated = "date_created"
        case address
        case userId = "user_id"
        case totalSum = "total_sum"
        case productsSum = "products_sum"
        case promocodeApplied = "promocode_applied"
    }
}

struct OrderProductsModel: Hashable, Codable {
    let productId: String
    let capacity: String
    let quantity: Int
    let dateCreated: Date
    let price: Int
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case capacity
        case quantity
        case dateCreated = "date_created"
        case price
    }
}

struct OrderedProduct: Identifiable, Hashable, Codable {
    let id: String
    let productId: String
    let quantity: Int
    let dateCreated: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case quantity
        case dateCreated = "date_created"
    }
}

enum OrderStatus: String, CaseIterable, Codable {
    case created = "Создан 🚀"
    case pending = "В обработке ⏱️"
    case delivered = "Доставлен 👍🏻"
    case cancelled = "Отменен"
}
