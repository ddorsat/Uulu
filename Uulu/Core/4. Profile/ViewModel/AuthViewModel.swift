//
//  AuthViewModel.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import Foundation
import AlertKit
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var basketViewModel = BasketViewModel()
    @Published private(set) var myOrdersViewModel = MyOrdersViewModel()
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var authState = AuthState.signedOut
    @Published var authRoutes: [AuthRoutes] = []
    @Published var showSignOut: Bool = false
    
    @Published var showInvalidSignInCredentials: Bool = false
    @Published var showSuccessfulSignInCredentials: Bool = false
    @Published var showInvalidSignUpCredentials: Bool = false
    @Published var showSuccessfulSignUpCredentials: Bool = false
    private(set) var invalidSignInCredentials = AlertAppleMusic17View(title: "Неверный E-mail или пароль", subtitle: nil, icon: .error)
    private(set) var successfulSignInCredentials = AlertAppleMusic17View(title: "Успешный вход", subtitle: nil, icon: .done)
    private(set) var invalidSignUpCredentials = AlertAppleMusic17View(title: "Введите корректные данные", subtitle: nil, icon: .error)
    private(set) var successfulSignUpCredentials = AlertAppleMusic17View(title: "Успешная регистрация!", subtitle: nil, icon: .done)
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        listenToAuthState()
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    func loadData() {
        basketViewModel.listenToBasket()
        Task { await myOrdersViewModel.fetchOrders() }
    }
    
    func listenToAuthState() {
        AuthService.shared.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authResult in
                self?.authState = authResult
            }
            .store(in: &subscriptions)
    }
    
    func clearFields() {
        username.removeAll()
        email.removeAll()
        password.removeAll()
    }
    
    func signIn() async {
        guard !email.isEmpty && !password.isEmpty else { return }
        let result = await AuthService.shared.signIn(email, password)
        
        if result != false {
            authRoutes.removeAll()
            showSuccessfulSignInCredentials.toggle()
        } else {
            showInvalidSignInCredentials.toggle()
        }
    }
    
    func signUp() async {
        guard !email.isEmpty && !password.isEmpty else { return }
        let result = await AuthService.shared.signUp(username, email, password)
        
        if result != false {
            authRoutes.removeAll()
            showSuccessfulSignUpCredentials.toggle()
        } else {
            showInvalidSignUpCredentials.toggle()
        }
    }
    
    func resetPassword() async {
        await AuthService.shared.resetPassword(email)
    }
    
    func signOut() {
        showSignOut = false
        AuthService.shared.signOut()
        authRoutes.removeAll()
    }
}

enum AuthRoutes: Hashable {
    case signIn
    case signUp
    case forgotPassword
    case forgotPasswordComplete
    case myOrders
    case myOrderDetails(_ order: OrderModel)
    case promocodes
    case basket
    case basketOrder
    case basketOrderComplete
    case productDetails(_ product: ProductModel)
}
