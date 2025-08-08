//
//  ProfileButton.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct SignedInButton: View {
    let button: SignedInButtons
    let onTapHandler: () -> Void
    
    var body: some View {
        Button {
            onTapHandler()
        } label: {
            VStack(alignment: .leading) {
                Text(button.rawValue)
                    .font(.system(size: UIDevice.ProMax ? 27 : 25))
                    .foregroundStyle(.black)
                
                Divider()
            }
        }
    }
}

enum SignedInButtons: String {
    case myOrders = "Мои заказы"
    case favorites = "Любимое"
    case basket = "Корзина"
    case promocodes = "Акции"
    case logOut = "Выйти"
}

#Preview {
    SignedInButton(button: .myOrders) {
        
    }
}
