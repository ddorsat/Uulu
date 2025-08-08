//
//  AuthTextField.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI

struct AuthTextField: View {
    @Binding var text: String
    let textField: AuthTextFields
    @FocusState var focused: Bool
    
    var isFocused: Color {
        return focused ? .gray.opacity(0.8) : .gray.opacity(0.33)
    }
    
    var body: some View {
        Group {
            if textField == .password {
                SecureField(textField.rawValue, text: $text)
            } else {
                TextField(textField.rawValue, text: $text)
                    .autocapitalization(.none)
            }
        }
        .font(.headline)
        .foregroundStyle(.black)
        .padding(.vertical, 14)
        .padding(.horizontal)
        .background(.gray.opacity(0.15))
        .focused($focused)
        .overlay {
            RoundedRectangle(cornerRadius: 0)
                .stroke(isFocused, lineWidth: 1)
        }
    }
}

enum AuthTextFields: String {
    case username = "Введите ваше имя"
    case email = "Введите вашу электронную почту"
    case password = "Введите ваш пароль"
}

#Preview {
    AuthTextField(text: .constant(""), textField: .password)
}
