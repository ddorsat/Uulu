//
//  OrdersService.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class OrdersService {
    static let shared = OrdersService()
    
    func fetchOrders() async throws -> [OrderModel] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await FBConstants.ordersRef
            .whereField("user_id", isEqualTo: currentUid)
            .order(by: "date_created", descending: true).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: OrderModel.self) }
    }
    
    func makeOrder(products: [BasketModel], address: String, totalSum: Int, promocodeApplied: Bool) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let basketRef = FBConstants.usersRef.document(currentUid).collection("basket")
        let productsRef = FBConstants.productsRef
        let ordersRef = FBConstants.ordersRef.document()
        
        do {
            let basketProducts = products
            guard !basketProducts.isEmpty else { return }
            
            var productsDict: [String: [String: Any]] = [:]
            let documentID = ordersRef.documentID
            var productsSum = 0
            
            for product in basketProducts {
                let capacity = product.capacity
                let productId = product.productId
                let orderQuantity = product.quantity ?? 1
                let productPrice = product.price
                
                let productDoc = productsRef.document(productId)
                let quantityPath = "variations.\(capacity).quantity"
                
                try await productDoc.updateData([quantityPath: FieldValue.increment(Int64(-orderQuantity))])
                
                productsDict[UUID().uuidString] = ["product_id": productId,
                                                   "price": productPrice,
                                                   "capacity": capacity,
                                                   "quantity": orderQuantity,
                                                   "date_created": Timestamp()]
                
                productsSum += productPrice * orderQuantity
            }

            let orderData: [String: Any] = [
                "uid": documentID,
                "products": productsDict,
                "status": OrderStatus.created.rawValue,
                "date_created": Timestamp(),
                "address": address,
                "user_id": currentUid,
                "total_sum": totalSum,
                "products_sum": productsSum,
                "promocode_applied": promocodeApplied]
            
            try await ordersRef.setData(orderData)
            
            for product in basketProducts {
                let productId = "\(product.productId)_\(product.capacity)"
                try await basketRef.document(productId).delete()
            }
        } catch {
            print("Failed to make order - \(error.localizedDescription)")
        }
    }
    
    func listenToOrder(orderId: String, completion: @escaping (OrderModel) -> Void) -> ListenerRegistration? {
        return FBConstants.ordersRef.document(orderId).addSnapshotListener { snapshot, _ in
            guard let order = try? snapshot?.data(as: OrderModel.self) else { return }
            completion(order)
        }
    }
    
    func cancelOrder(orderId: String) async {
        do {
            let ref = FBConstants.ordersRef.document(orderId)
            try await ref.updateData(["status": OrderStatus.cancelled.rawValue])
        } catch {
            print("Failed to cancel order - \(error.localizedDescription)")
        }
    }
}
