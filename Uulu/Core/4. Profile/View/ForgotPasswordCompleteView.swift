//
//  PasswordResetCompleteView.swift
//  Uulu
//
//  Created by ddorsat on 22.07.2025.
//

import SwiftUI

struct ForgotPasswordCompleteView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            EmptyViewComponent.emptyView(title: "Готово",
                                                description: "Вернитесь назад, чтобы авторизоваться",
                                                buttonTitle: "Назад") {
                viewModel.authRoutes.removeAll()
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("Сброс пароля")
        .navigationBarBackButtonHidden()
        .toolbar {
            ButtonComponents.backButton {
                viewModel.authRoutes.removeAll()
            }
        }
    }
}


#Preview {
    ForgotPasswordCompleteView(viewModel: AuthViewModel())
}
