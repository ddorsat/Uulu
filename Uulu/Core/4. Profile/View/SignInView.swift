//
//  LogInView.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: UIDevice.ProMax ? 50 : 30) {
            AuthComponents.title(.signIn)
                .padding(.vertical, UIDevice.ProMax ? 70 : 45)
            
            VStack(spacing: 15) {
                AuthTextField(text: $viewModel.email, textField: .email)
                
                AuthTextField(text: $viewModel.password, textField: .password)
                
                Button {
                    viewModel.authRoutes.append(.forgotPassword)
                } label: {
                    Text("Забыл пароль")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 10)
                }
            }
            
            AuthButton(button: .logIn) {
                Task { await viewModel.signIn() }
            }
            
            AuthComponents.divider()
            
            VStack(spacing: 15) {
                AuthButton(button: .google) {
                    
                }
                
                AuthButton(button: .twitter) {
                    
                }
            }
        }
        .padding(.horizontal, 20)
        .onDisappear {
            viewModel.clearFields()
        }
        .alert(isPresent: $viewModel.showInvalidSignInCredentials, view: viewModel.invalidSignInCredentials)
        .alert(isPresent: $viewModel.showSuccessfulSignInCredentials, view: viewModel.successfulSignInCredentials)
    }
}


#Preview {
    SignInView(viewModel: AuthViewModel())
}
