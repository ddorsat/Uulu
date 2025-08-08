//
//  PromocodeView.swift
//  Uulu
//
//  Created by ddorsat on 23.07.2025.
//

import SwiftUI

struct PromocodesView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("sale")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 10)
        .scrollIndicators(.hidden)
        .navigationTitle("Акции")
    }
}

#Preview {
    PromocodesView()
}
