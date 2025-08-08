//
//  OrderDetailsViewModel.swift
//  Uulu
//
//  Created by ddorsat on 22.07.2025.
//

import Foundation
import FirebaseFirestore

final class MyOrderDetailsViewModel: ObservableObject {
    @Published private(set) var order: OrderModel
    @Published var showCancel: Bool = false
    
    var isCancelled: Bool {
        order.status == .cancelled
    }
    private var listener: ListenerRegistration? = nil
    
    init(order: OrderModel) {
        self.order = order
        listenToOrder(order)
    }
    
    deinit {
        listener = nil
        listener?.remove()
    }
    
    func cancelOrder(orderId: String) async {
        showCancel = false
        await OrdersService.shared.cancelOrder(orderId: orderId)
    }
    
    func listenToOrder(_ order: OrderModel) {
        self.listener = OrdersService.shared.listenToOrder(orderId: order.uid) { [weak self] updatedOrder in
            self?.order = updatedOrder
        }
    }
}
