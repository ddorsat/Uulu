//
//  OrderDetailsView.swift
//  Uulu
//
//  Created by ddorsat on 20.07.2025.
//

import SwiftUI

struct MyOrderDetailsView: View {
    @StateObject var myOrderDetailsViewModel: MyOrderDetailsViewModel
    @ObservedObject var authViewModel = AuthViewModel()
    
    init(orderDetailsViewModel: MyOrderDetailsViewModel,
         authViewModel: AuthViewModel,
         order: OrderModel) {
        self._myOrderDetailsViewModel = StateObject(wrappedValue: MyOrderDetailsViewModel(order: order))
        self.authViewModel = authViewModel
    }
    
    private var order: OrderModel {
        myOrderDetailsViewModel.order
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Заказ #\(order.uid.prefix(8).uppercased())")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "location")
                            .foregroundStyle(.gray)
                            .font(.title2)
                        
                        Text(order.address)
                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "calendar")
                            .foregroundStyle(.gray)
                            .font(.title2)
                        
                        Text(order.dateCreated.formatTime())
                    }
                }
                .font(.system(size: UIDevice.ProMax ? 20 : 18))
                .fontWeight(.light)
                
                ForEach(order.productsSorted, id: \.self) { product in
                    OrderDetailsBuilder(productId: product.productId,
                                        productQuantity: product.quantity,
                                        productPrice: product.price,
                                        productCapacity: product.capacity) { product in 
                        authViewModel.authRoutes.append(.productDetails(product))
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("В вашем заказе")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    HStack {
                        if order.promocodeApplied {
                            Text("Скидка 21%")
                            
                            Spacer()
                            
                            Text("\(order.productsSum) ₽")
                                .overlay {
                                    Rectangle()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                }
                        }
                    }
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                    
                    HStack {
                        Text("Итого")
                        
                        Spacer()
                        
                        Text("\(order.totalSum) ₽")
                            .foregroundStyle(order.promocodeApplied ? .red : .black)
                    }
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.bottom, 10)
                    
                    Divider()
                }
                
                ButtonComponents.blackButton(title: myOrderDetailsViewModel.isCancelled ? "Отменен" : "Отменить заказ",
                                             isCancelled: myOrderDetailsViewModel.isCancelled) {
                    myOrderDetailsViewModel.showCancel = true
                }
            }
        }
        .alert("Вы точно хотите отменить заказ?", isPresented: $myOrderDetailsViewModel.showCancel) {
            Button("Отменить заказ", role: .destructive) {
                Task { await myOrderDetailsViewModel.cancelOrder(orderId: order.uid) }
            }
        }
        .padding([.top, .horizontal], 20)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .navigationTitle("Состав заказа")
        .scrollIndicators(.hidden)
    }
}
