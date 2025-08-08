//
//  BasketOrderView.swift
//  Uulu
//
//  Created by ddorsat on 20.07.2025.
//

import SwiftUI

struct BasketOrderView: View {
    @ObservedObject var viewModel: BasketViewModel
    @FocusState var address: Bool
    @FocusState var apartment: Bool
    @FocusState var houseNumber: Bool
    @FocusState var promoCode: Bool
    let orderCompleteHandler: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 55) {
                VStack(alignment: .leading, spacing: 25) {
                    TextFieldComponents.orderTextField(field: "Введите ваш адрес", bindText: $viewModel.address, isFocused: $address)
                    
                    HStack(spacing: 15) {
                        TextFieldComponents.orderTextField(field: "Дом", bindText: $viewModel.houseNumber, isFocused: $houseNumber)
                        
                        TextFieldComponents.orderTextField(field: "Квартира", bindText: $viewModel.apartment, isFocused: $apartment)
                    }
                }
                
                VStack(alignment: .leading, spacing: 35) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Оплата")
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                    }
                    
                    VStack(spacing: 12) {
                        HStack {
                            if viewModel.promocodeApplied {
                                Text("Скидка 21%")
                                
                                Spacer()
                                
                                Text("\(viewModel.productsTotalSum) ₽")
                                    .overlay {
                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 2)
                                    }
                            }
                        }
                        
                        HStack {
                            Text("Итого")
                            
                            Spacer()
                            
                            Text("\(viewModel.totalSum) ₽")
                                .foregroundStyle(viewModel.promocodeApplied ? .red : .black)
                        }
                    }
                    .font(.title2)
                    .minimumScaleFactor(0.8)
                    .fontWeight(.medium)
                    
                    TextFieldComponents.promoCodeTextField(promoCode: $viewModel.promocode, isFocused: promoCode) {
                        viewModel.applyPromocode()
                    }
                    .focused($promoCode)
                    
                    
                    ButtonComponents.blackButton(title: "Оплатить" + "  |  " + "\(viewModel.totalSum) ₽") {
                        guard !viewModel.address.isEmpty else { return }
                        
                        Task { await viewModel.orderFromBasket() }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            orderCompleteHandler()
                        }
                    }
                }
            }
            .padding([.top, .horizontal], 20)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 70) }
    }
}

#Preview {
    BasketOrderView(viewModel: BasketViewModel()) {
        
    }
}
