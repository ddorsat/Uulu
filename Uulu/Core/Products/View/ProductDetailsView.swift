//
//  ProductDetailsView.swift
//  Uulu
//
//  Created by ddorsat on 02.07.2025.
//

import SwiftUI
import FirebaseAuth

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    @State private var selectedVariation: String = ""
    let loggedOutHandler: () -> Void
    
    private var product: ProductModel { viewModel.product }
    private var productIsEmpty: Bool {
        viewModel.product.variations.values.allSatisfy { $0.quantity == 0 }
    }
    private var productPrice: String {
        if selectedVariation.isEmpty {
            return String(product.minPrice)
        } else {
            return String(product.variations[selectedVariation]?.price ?? 0)
        }
    }
    
    init(product: ProductModel, loggedOutHandler: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: product))
        self.loggedOutHandler = loggedOutHandler
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                TabView {
                    ForEach(product.images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                }
                .padding(.horizontal, -20)
                .frame(height: UIScreen.main.bounds.height / 2.2)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.medium)
                    
                    Text(product.description)
                        .font(.title3)
                        .foregroundStyle(.gray.opacity(0.8))
                        .lineLimit(1)
                    
                    Text("\(productPrice) ₽")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .animation(.easeInOut(duration: 0.2), value: selectedVariation)
                
                HStack(spacing: 15) {
                    ForEach(Array(product.variations.keys.sorted()), id: \.self) { capacity in
                        ProductCapacityButton(capacity: capacity, isSelected: selectedVariation == capacity) {
                            if selectedVariation == capacity {
                                selectedVariation = ""
                                viewModel.quantityInBasket = 0
                            } else {
                                selectedVariation = capacity
                                viewModel.listenToQuantity(capacity: capacity)
                            }
                        }
                    }

                    ProductCapacityText()
                }
                
                if productIsEmpty {
                    HStack(spacing: 15) {
                        ButtonComponents.basketBlackButton(title: "Закончилось", color: Color(.systemGray2))
                            .disabled(selectedVariation.isEmpty)
                        
                        ProductFavoritesButton(viewModel: viewModel) {
                            if Auth.auth().currentUser != nil {
                                Task { await viewModel.addToFavorites(product) }
                            } else {
                                loggedOutHandler()
                            }
                        }
                    }
                } else {
                    HStack(spacing: 15) {
                        ProductBasketButton(quantity: $viewModel.quantityInBasket,
                                            selectedVariation: $selectedVariation,
                                            product: product,
                                            maxQuantity:
                                            product.variations[selectedVariation]?.quantity ?? 0) {
                            if let variation = product.variations[selectedVariation] {
                                if Auth.auth().currentUser != nil {
                                    Task { await viewModel.addToBasket(capacity: selectedVariation, variation: variation) }
                                } else {
                                    loggedOutHandler()
                                }
                            }
                        } onDecrement: {
                            Task { await viewModel.removeFromBasket(capacity: selectedVariation) }
                        }
                        .disabled(selectedVariation.isEmpty)
                        
                        ProductFavoritesButton(viewModel: viewModel) {
                            if Auth.auth().currentUser != nil {
                                Task { await viewModel.addToFavorites(product) }
                            } else {
                                loggedOutHandler()
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Описание")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                    
                    Divider()
                    
                    Text(product.fullDescription)
                        .font(.system(size: 19))
                        .foregroundStyle(.gray)
                }
                
                VStack(spacing: 10) {
                    ProductDescription(desc: .productType(product.productType))
                    ProductDescription(desc: .gender(product.gender))
                    ProductDescription(desc: .brand(product.brand))
                    ProductDescription(desc: .use(product.use))
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 50)
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .animation(.easeInOut(duration: 0.2), value: selectedVariation)
    }
}

#Preview {
    ProductDetailsView(product: .placeholder) {
        
    }
}
