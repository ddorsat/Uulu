//
//  BasketView.swift
//  Uulu
//
//  Created by ddorsat on 14.07.2025.
//

import SwiftUI

struct BasketView: View {
    @ObservedObject var viewModel: BasketViewModel
    @FocusState var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    let onRouteHandler: (_ product: ProductModel) -> Void
    let onSearchRoute: () -> Void
    let onCatalogRoute: () -> Void
    let orderButton: () -> Void
    
    private var clearAllButton: Bool {
        viewModel.products.isEmpty
    }
    
    var body: some View {
        ScrollView {
            if viewModel.basketIsEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 5) {
                        Text("Воспользуйтесь")
                        
                        Text("поиском")
                            .onTapGesture {
                                onSearchRoute()
                            }
                            .foregroundStyle(Color(.systemGray4))
                        
                        Text("или")
                    }
                    HStack(spacing: 5) {
                        Text("каталогом")
                            .onTapGesture {
                                onCatalogRoute()
                            }
                            .foregroundStyle(Color(.systemGray4))
                        
                        Text("чтобы найти всё, что нужно")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .fontWeight(.medium)
                .foregroundColor(Color(.systemGray2))
                .padding(.top, 30)
            } else {
                VStack(spacing: 35) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.products, id: \.self) { product in
                            BasketCellBuilder(productID: product.productId,
                                              productOrder: product,
                                              productQuantity: product.productQuantity,
                                              productCapacity: product.capacity,
                                              productPrice: product.productPrice) { product in
                                Task { await viewModel.addToFavorites(product) }
                            } onRemoveHandler: { product in
                                viewModel.productToDelete = product
                                viewModel.showDeleteProduct = true
                            } onTapHandler: { product in
                                onRouteHandler(product)
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(spacing: 30) {
                        TextFieldComponents.promoCodeTextField(promoCode: $viewModel.promocode, isFocused: isFocused) {
                            viewModel.applyPromocode()
                        }
                        .focused($isFocused)
                        
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
                    }
                    
                    ButtonComponents.blackButton(title: "Заказать") {
                        orderButton()
                    }
                }
            }
        }
        .onDisappear {
            dismiss()
        }
        .padding([.top, .horizontal], 20)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 100) }
        .navigationTitle("Корзина")
        .scrollIndicators(.hidden)
        .alert("Вы точно хотите удалить товар?", isPresented: $viewModel.showDeleteProduct) {
            Button("Удалить", role: .destructive) {
                guard let productToDelete = viewModel.productToDelete else { return }
                
                Task { await viewModel.deleteFromBasket(productToDelete) }
            }
        }
        .alert("Очистить корзину?", isPresented: $viewModel.showClearAll) {
            Button("Очистить", role: .destructive) {
                Task { await viewModel.clearBasket() }
            }
        }
        .alert(isPresent: $viewModel.invalidPromocode, view: viewModel.invalidPromocodeAlert)
        .alert(isPresent: $viewModel.validPromocode, view: viewModel.validPromocodeAlert)
        .toolbar {
            clearAll()
        }
    }
}

extension BasketView {
    @ToolbarContentBuilder
    private func clearAll() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.showClearAll = true
            } label: {
                Text("Очистить все")
                    .grayscale(clearAllButton ? 1 : 0)
                    .disabled(clearAllButton)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BasketView(viewModel: BasketViewModel()) { _ in
            
        } onSearchRoute: {
            
        } onCatalogRoute: {
            
        } orderButton: {
            
        }
    }
}
