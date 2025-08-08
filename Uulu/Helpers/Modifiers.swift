//
//  Modifiers.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct AuthButtonModifier: ViewModifier {
    let button: AuthButtons
    
    func body(content: Content) -> some View {
        if button == .google || button == .signUp {
            content
                .overlay {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(.black, lineWidth: 1)
                }
        } else if button == .twitter {
            content
                .background(.black.opacity(0.84))
        } else {
            content
                .background(.black)
        }
    }
}

struct FilterPriceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .padding(10)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
