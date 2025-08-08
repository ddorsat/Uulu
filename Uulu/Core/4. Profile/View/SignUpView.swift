//
//  RegistrationView.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: UIDevice.ProMax ? 50 : 30) {
            AuthComponents.title(.signUp)
                .padding(.vertical, UIDevice.ProMax ? 65 : 40)
            
            VStack(spacing: 15) {
                AuthTextField(text: $viewModel.username, textField: .username)
                
                AuthTextField(text: $viewModel.email, textField: .email)
                
                AuthTextField(text: $viewModel.password, textField: .password)
            }
            
            AuthButton(button: .signUpField) {
                Task { await viewModel.signUp() }
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
        .alert(isPresent: $viewModel.showInvalidSignUpCredentials, view: viewModel.invalidSignUpCredentials)
        .alert(isPresent: $viewModel.showSuccessfulSignUpCredentials, view: viewModel.successfulSignUpCredentials)
    }
}

#Preview {
    SignUpView(viewModel: AuthViewModel())
}
