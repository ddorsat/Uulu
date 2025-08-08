//
//  DescriptionView.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import SwiftUI

struct ProductDescription: View {
    let desc: Descriptions
    
    var body: some View {
        HStack {
            Text(desc.title)
                .font(.system(size: 17))
                .foregroundStyle(.gray)
                .layoutPriority(3)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.systemGray3))
                .frame(maxWidth: .infinity)
                .layoutPriority(0)
            
            Text(desc.options)
                .font(.system(size: 17))
                .fontWeight(.medium)
                .lineLimit(2)
                .layoutPriority(1)
        }
        .minimumScaleFactor(0.7)
    }
}

enum Descriptions {
    case brand(Brands)
    case productType(ProductType)
    case gender(Gender)
    case use(Use)
    case category(Category)
    
    var title: String {
        switch self {
            case .productType:
                return "Тип продукта"
            case .gender:
                return "Для кого"
            case .brand:
                return "Бренд"
            case .use:
                return "Применение"
            case .category:
                return "Категория"
        }
    }
    
    var options: String {
        switch self {
            case .productType(let type): return type.rawValue
            case .gender(let gender): return gender.rawValue
            case .brand(let brand): return brand.rawValue
            case .use(let use): return use.rawValue
            case .category(let category): return category.rawValue
        }
    }
    
    enum ProductType: String, CaseIterable, Codable {
        case eyebrowPencil = "Автоматический карандаш для бровей"
        case balm = "Бальзам"
        case lipsBalm = "Бальзам для губ"
        case cologne = "Одеколон"
        case deodorant = "Дезодорант"
        case eyebrowGel = "Гель для бровей"
        case showerGel = "Гель для душа"
        case eyelinerMarker = "Подводка-маркер для век"
        case lipMakeupBase = "Основа для макияжа губ"
        case lipstickBalm = "Губная помада-бальзам"
        case nailPolish = "Лак для ногтей"
        case lipsPencil = "Карандаш для губ"
        case hairDye = "Краска для волос"
        case cream = "Крем"
        case faceBlush = "Румяна для лица"
        case seaSalt = "Морская соль"
        case mascara = "Тушь для ресниц"
        case nailTopCoating = "Топовое покрытие для ногтей"
        case foundation = "Тональный крем для лица"
        case toiletWater = "Туалетная вода"
        case lipstick = "Помада для губ"
        case conditioner = "Кондиционер"
        case serum = "Сыворотка"
        case shampoo = "Шампунь"
        case perfumeWater = "Парфюмерная вода"
    }
    
    enum Gender: String, Codable {
        case man = "Для него"
        case woman = "Для нее"
        case unisex = "Унисекс"
    }
    
    enum Use: String, Codable {
        case faceAndBody = "Лицо и тело"
        case face = "Лицо"
        case body = "Тело"
        case hair = "Волосы"
        case hands = "Руки"
        case nails = "Ногти"
        case lips = "Губы"
        case eyebrows = "Брови"
        case eyelids = "Веки"
        case eyelashes = "Ресницы"
    }
    
    enum Category: String, Codable {
        case perfume  = "Парфюмерия"
        case skincare = "Уход за кожей"
        case makeup   = "Макияж"
        case bodycare = "Уход за телом"
        case haircare = "Уход за волосами"
        case hygiene  = "Гигиена"
    }
}

#Preview {
    ProductDescription(desc: .productType(.cream))
    ProductDescription(desc: .gender(.man))
    ProductDescription(desc: .brand(.aDerma))
}
