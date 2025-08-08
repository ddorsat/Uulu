//
//  MyOrdersViewModel.swift
//  Uulu
//
//  Created by ddorsat on 19.07.2025.
//

import SwiftUI
import FirebaseFirestore

final class MyOrdersViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var orderProducts: OrderModel? = nil
    
    private var orderListener: ListenerRegistration? = nil
    
    deinit {
        orderListener = nil
        orderListener?.remove()
    }
    
    func fetchOrders() async {
        do {
            self.orders = try await OrdersService.shared.fetchOrders()
            listenToOrders()
        } catch {
            print("Failed to fetch orders - \(error.localizedDescription)")
        }
    }
    
    private func listenToOrders() {
        for order in orders {
            let listener = OrdersService.shared.listenToOrder(orderId: order.uid) { [weak self] updatedOrder in
                if let index = self?.orders.firstIndex(where: { $0.uid == updatedOrder.uid }) {
                    self?.orders[index] = updatedOrder
                }
            }
            
            self.orderListener = listener
        }
    }
}
