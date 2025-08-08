//
//  AuthButton.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct AuthButton: View {
    let button: AuthButtons
    let onTapHandler: () -> Void
    
    var body: some View {
        Button {
            onTapHandler()
        } label: {
            Text(button.title)
                .foregroundStyle(button.foregroundColor)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .modifier(AuthButtonModifier(button: button))
                .overlay(alignment: .leading) {
                    if let icon = button.icon {
                        Image(icon)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.leading)
                    }
                }
        }
    }
}

enum AuthButtons: String {
    case signIn, signUp, signUpField, logIn, create, google, twitter
    
    var title: String {
        switch self {
            case .signIn:
                return "Войти"
            case .signUp:
                return "Регистрация"
            case .signUpField:
                return "Регистрация"
            case .logIn:
                return "Войти"
            case .create:
                return "Создать аккаунт"
            case .google:
                return "Google"
            case .twitter:
                return "X"
        }
    }
    
    var foregroundColor: Color {
        switch self {
            case .google, .signUp:
                return .black
            default:
                return .white
        }
    }
    
    var icon: String? {
        switch self {
            case .google:
                return "google"
            case .twitter:
                return "twitter"
            default:
                return nil
        }
    }
}

#Preview {
    AuthButton(button: .signIn) {
        
    }
    .padding(.horizontal)
}
