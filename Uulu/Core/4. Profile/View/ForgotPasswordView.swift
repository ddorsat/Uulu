//
//  PasswordResetView.swift
//  Uulu
//
//  Created by ddorsat on 22.07.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 35) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Введите вашу почту")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                TextField("Введите ваш E-mail", text: $viewModel.email)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(.gray.opacity(0.15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                    }
                    .autocapitalization(.none)
                    .onDisappear {
                        viewModel.clearFields()
                    }
            }
            
            ButtonComponents.blackButton(title: "Отправить") {
                guard !viewModel.email.isEmpty else { return }
                
                Task {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await viewModel.resetPassword()
                    viewModel.authRoutes.append(.forgotPasswordComplete)
                }
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("Сброс пароля")
    }
}

#Preview {
    ForgotPasswordView(viewModel: AuthViewModel())
}
