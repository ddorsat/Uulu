//
//  Components.swift
//  Uulu
//
//  Created by ddorsat on 25.06.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AuthComponents {
    static func title(_ authTitle: AuthTitle) -> some View {
        Text(authTitle.rawValue)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    static func divider() -> some View {
        ZStack {
            Text("ИЛИ")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.black)
                .clipShape(Capsule())
            
            Divider()
        }
    }
    
    enum AuthTitle: String {
        case signIn = "Войти"
        case signUp = "Регистрация"
        case signedOut = "Войти в личный кабинет"
    }
}

struct ButtonComponents {
    static func clearFilterSelection(completion: @escaping () -> Void) -> some View {
        Button {
            completion()
        } label: {
            Text("Очистить")
        }
    }
    
    @ToolbarContentBuilder
    static func backButton(completion: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                completion()
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
            }
        }
    }
    
    @ToolbarContentBuilder
    static func basketButton(completion: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                completion()
            } label: {
                Image(systemName: "bag")
            }
        }
    }
    
    static func blackButton(title: String, isCancelled: Bool? = nil, completion: @escaping () -> Void) -> some View {
        Button {
            completion()
        } label: {
            Text(title)
                .foregroundStyle(isCancelled ?? false ? .gray : .white)
                .font(.title3)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.black)
        }
    }
    
    static func basketBlackButton(title: String, color: Color, completion: (() -> Void)? = nil) -> some View {
        Button {
            completion?()
        } label: {
            Text(title)
                .foregroundStyle(color)
                .font(.title3)
                .minimumScaleFactor(0.8)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 14)
                .background(.black)
        }
    }
}

struct TextFieldComponents {
    static func orderTextField(field: String, bindText: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(field)
                .font(.system(size: UIDevice.ProMax ? 20 : 18))
                .foregroundStyle(.gray)
                .fontWeight(.light)
            
            TextField("", text: bindText)
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background(Color(.systemGray6))
                .overlay {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(isFocused.wrappedValue ? Color(.systemGray4) : Color(.systemGray5))
                }
                .focused(isFocused)
        }
    }
    
    static func promoCodeTextField(promoCode: Binding<String>, isFocused: Bool, onTapHandler: @escaping () -> Void) -> some View {
        TextField("Введите промокод", text: promoCode)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isFocused ? Color(.systemGray2) : Color(.systemGray4), lineWidth: 1)
            }
            .padding(.horizontal, 1)
            .overlay(alignment: .trailing) {
                Button {
                    onTapHandler()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(isFocused ? Color(.systemGray4) : Color(.systemGray6))
                        .clipShape(Circle())
                        .padding(.trailing)
                }
            }
    }
}

struct EmptyViewComponent {
    static func emptyView(title: String,
                          description: String,
                          buttonTitle: String,
                          onTapHandler: @escaping () -> Void) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.title3)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
            
            ButtonComponents.blackButton(title: buttonTitle) {
                onTapHandler()
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
}

struct MenuComponents {
    @ToolbarContentBuilder
    static func makeMenu<T: CaseIterable & RawRepresentable>(_ options: T.Type, completion: @escaping (T) -> Void) -> some ToolbarContent where T.RawValue == String, T: Hashable {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                ForEach(Array(T.allCases), id: \.self) { option in
                    Button(option.rawValue) {
                        completion(option)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundStyle(.black.opacity(0.8))
                    .imageScale(.large)
            }
        }
    }
}

struct BasketComponents {
    static func correctProductsPostfix(_ count: Int) -> String {
        let lastTwo = count % 100
        let last = count % 10

        if lastTwo >= 11 && lastTwo <= 14 {
            return "товаров"
        }

        switch last {
            case 1:
                return "товар"
            case 2...4:
                return "товара"
            default:
                return "товаров"
        }
    }
}
