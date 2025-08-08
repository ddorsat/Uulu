//
//  FeedCell.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import SwiftUI
import FirebaseAuth

struct ProductCellView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    let sliding: Bool
    let loggedOutHandler: () -> Void
    
    var product: ProductModel {
        viewModel.product
    }
    
    init(product: ProductModel, sliding: Bool, loggedOutHandler: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: product))
        self.sliding = sliding
        self.loggedOutHandler = loggedOutHandler
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if sliding {
                TabView {
                    ForEach(product.images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 2.25,
                                   height: UIScreen.main.bounds.height / 4)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .background(Color(.systemGray6))
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            } else {
                if let image = product.images.first {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.5,
                               height: UIScreen.main.bounds.height / 4)
                        .clipped()
                        .background(Color(.systemGray6))
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2.15, alignment: .leading)
                
                Text(product.description)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(.systemGray2))
                    .lineLimit(1)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2.25, alignment: .leading)
                
                if viewModel.productIsEmpty {
                    Text("Закончилось")
                        .foregroundStyle(Color(.systemGray2))
                        .fontWeight(.semibold)
                } else {
                    Text("\(product.minPrice) ₽")
                        .fontWeight(.semibold)
                }
            }
        }
        .foregroundStyle(.black)
        .frame(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.height / 3)
        .overlay(alignment: .topTrailing) {
            Button {
                if Auth.auth().currentUser != nil {
                    Task { await viewModel.addToFavorites(product) }
                } else {
                    loggedOutHandler()
                }
            } label: {
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 27))
                    .foregroundStyle(product.isFavorite ? .red : .black)
                    .padding(sliding ? 8 : 10)
                    .padding(.horizontal, sliding ? 0 : -10)
            }
        }
    }
}


#Preview {
    ProductCellView(product: .placeholder, sliding: true) {
        
    }
}
