//
//  ProfileView.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct SignedInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var selectedTab: Tabs
    let currentUser: UserModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                titleView(title: currentUser.username, fontSize: UIDevice.ProMax ? 45 : 40)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 15) {
                    titleView(title: "Мой аккаунт", fontSize: UIDevice.ProMax ? 28 : 25)
                    
                    Divider()
                    
                    SignedInButton(button: .myOrders) {
                        viewModel.authRoutes.append(.myOrders)
                    }
                    
                    SignedInButton(button: .favorites) {
                        selectedTab = .favorites
                    }
                    
                    SignedInButton(button: .basket) {
                        viewModel.authRoutes.append(.basket)
                    }
                    
                    SignedInButton(button: .promocodes) {
                        viewModel.authRoutes.append(.promocodes)
                    }
                }
                
                VStack {
                    SignedInButton(button: .logOut) {
                        viewModel.showSignOut = true
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
        .padding(.leading, 20)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .alert("Вы точно хотите выйти?", isPresented: $viewModel.showSignOut) {
            Button("Выйти", role: .destructive) {
                viewModel.signOut()
            }
        }
        .toolbar {
            ButtonComponents.basketButton {
                viewModel.authRoutes.append(.basket)
            }
        }
    }
}

extension SignedInView {
    private func titleView(title: String, fontSize: CGFloat) -> some View {
        Text(title)
            .font(.system(size: fontSize))
            .minimumScaleFactor(0.8)
            .fontWeight(.semibold)
    }
}

#Preview {
    SignedInView(viewModel: AuthViewModel(), selectedTab: .constant(.profile), currentUser: .placeholder)
}
