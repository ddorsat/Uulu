//
//  MyOrdersView.swift
//  Uulu
//
//  Created by ddorsat on 19.07.2025.
//

import SwiftUI

struct MyOrdersView: View {
    @ObservedObject var viewModel: MyOrdersViewModel
    let catalogHandler: () -> Void
    let orderDetails: (OrderModel) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 13) {
                if viewModel.orders.isEmpty {
                    EmptyViewComponent.emptyView(
                        title: "Заказов нет",
                        description: "Делайте заказы, чтобы радовать себя и близких!",
                        buttonTitle: "В каталог") {
                        catalogHandler()
                    }
                } else {
                    ForEach(viewModel.orders, id: \.self) { order in
                        MyOrdersCell(order: order) {
                            orderDetails(order)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.top, 20)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .navigationTitle("Мои заказы")
    }
}

#Preview {
    NavigationStack {
        MyOrdersView(viewModel: MyOrdersViewModel()) { 
            
        } orderDetails: { _ in
            
        }
    }
}
