//
//  BasketOrderCompleteView.swift
//  Uulu
//
//  Created by ddorsat on 21.07.2025.
//

import SwiftUI

struct BasketOrderCompleteView: View {
    let catalogHandler: () -> Void
    let backButtonHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            EmptyViewComponent.emptyView(title: "Заказ оформлен",
                                                description: "Скоро начнем собирать!",
                                                buttonTitle: "Каталог") {
                catalogHandler()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ButtonComponents.backButton {
                backButtonHandler()
            }
        }
    }
}


#Preview {
    BasketOrderCompleteView() {
        
    } backButtonHandler: {
        
    }
}
