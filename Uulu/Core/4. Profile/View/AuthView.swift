//
//  RootView.swift
//  Uulu
//
//  Created by ddorsat on 26.06.2025.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Binding var selectedTab: Tabs
    
    var body: some View {
        NavigationStack(path: $viewModel.authRoutes) {
            Group {
                if case .signedIn(let user) = viewModel.authState {
                    SignedInView(viewModel: viewModel,
                                 selectedTab: $selectedTab,
                                 currentUser: user)
                } else {
                    SignedOutView(viewModel: viewModel)
                }
            }
            .navigationDestination(for: AuthRoutes.self) { route in
                destinationView(route: route)
            }
        }
    }
}

extension AuthView {
    @ViewBuilder
    private func destinationView(route: AuthRoutes) -> some View {
        switch route {
            case .signIn:
                SignInView(viewModel: viewModel)
            case .signUp:
                SignUpView(viewModel: viewModel)
            case .forgotPassword:
                ForgotPasswordView(viewModel: viewModel)
            case .forgotPasswordComplete:
                ForgotPasswordCompleteView(viewModel: viewModel)
            case .myOrders:
                MyOrdersView(viewModel: viewModel.myOrdersViewModel) {
                    selectedTab = .catalog
                } orderDetails: { order in
                    viewModel.authRoutes.append(.myOrderDetails(order))
                }
            case .myOrderDetails(let order):
                MyOrderDetailsView(orderDetailsViewModel: MyOrderDetailsViewModel(order: order),
                                   authViewModel: viewModel,
                                   order: order)
            case .promocodes:
                PromocodesView()
            case .basket:
                BasketView(viewModel: viewModel.basketViewModel) { product in
                    viewModel.authRoutes.append(.productDetails(product))
                } onSearchRoute: {
                    selectedTab = .search
                } onCatalogRoute: {
                    selectedTab = .catalog
                } orderButton: {
                    viewModel.authRoutes.append(.basketOrder)
                }
            case .basketOrder:
                BasketOrderView(viewModel: viewModel.basketViewModel) {
                    viewModel.authRoutes.append(.basketOrderComplete)
                }
            case .basketOrderComplete:
                BasketOrderCompleteView() {
                    selectedTab = .catalog
                } backButtonHandler: {
                    viewModel.authRoutes.removeAll()
                }
            case .productDetails(let product):
                ProductDetailsView(product: product) {
                    selectedTab = .profile
                }
        }
    }
}

#Preview {
    AuthView(selectedTab: .constant(.profile))
}
