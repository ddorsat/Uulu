//
//  MyOrdersCell.swift
//  Uulu
//
//  Created by ddorsat on 19.07.2025.
//

import SwiftUI

struct MyOrdersCell: View {
    let order: OrderModel
    let onTapHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "bag")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.status.rawValue)
                        .font(.system(size: UIDevice.ProMax ? 20 : 19))
                        .fontWeight(.medium)
                    
                    Text("\(order.dateCreated.formatTime())")
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
                .layoutPriority(1)
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("\(order.totalSum) ₽")
                        .font(.system(size: UIDevice.ProMax ? 20 : 19))
                        .fontWeight(.medium)
                    
                    let quantity = order.products.values.map { $0.quantity }.reduce(0, +)
                    let products = BasketComponents.correctProductsPostfix(quantity)
                    
                    Text("\(quantity) \(products)")
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                }
                .layoutPriority(2)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(.systemGray2))
                    .fontWeight(.medium)
            }
            
            Divider()
        }
        .onTapGesture {
            onTapHandler()
        }
        .frame(height: UIScreen.main.bounds.height / 11)
    }
}
