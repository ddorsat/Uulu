//
//  SignInView.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct SignedOutView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            AuthComponents.title(.signedOut)
            
            Spacer()
            
            VStack(spacing: 20) {
                AuthButton(button: .signIn) {
                    viewModel.authRoutes.append(.signIn)
                }
                
                AuthButton(button: .signUp) {
                    viewModel.authRoutes.append(.signUp)
                }
            }
            
            Spacer()
            
            bottomText()
        }
        .padding(.horizontal, 20)
    }
}

extension SignedOutView {
    private func bottomText() -> some View {
        Text("При входе и регистрации вы соглашаетесь с политикой обработки персональных данных.")
            .font(.system(size: 14))
            .foregroundStyle(.gray.opacity(0.8))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 15)
    }
}

#Preview {
    SignedOutView(viewModel: AuthViewModel())
}
