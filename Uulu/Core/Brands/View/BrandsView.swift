//
//  BrandsView.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct BrandsView: View {
    @ObservedObject var viewModel: BrandsViewModel
    @State private var selection: Gender = .women
    @Binding var searchRoutes: [SearchRoutes]
    let loggedOutHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                ForEach(Gender.allCases, id: \.self) { section in
                    VStack(alignment: .leading, spacing: 7) {
                        Text(section.rawValue)
                            .font(.title3)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.8)
                            .onTapGesture {
                                selection = section
                            }
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(selection == section ? .black : .clear)
                            .animation(.easeInOut, value: section)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            
            ScrollView {
                Group {
                    if selection == .women {
                        WomenBrands(viewModel: viewModel, searchRoutes: $searchRoutes) {
                            loggedOutHandler()
                        }
                    } else if selection == .men {
                        MenBrands(viewModel: viewModel, searchRoutes: $searchRoutes) {
                            loggedOutHandler()
                        }
                    } else {
                        UnisexBrands(viewModel: viewModel, searchRoutes: $searchRoutes) {
                            loggedOutHandler()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding([.top, .horizontal], 20)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
        .animation(.smooth, value: selection)
        .navigationTitle("Бренды")
        .toolbar {
            ButtonComponents.basketButton {
                
            }
        }
    }
}

enum Gender: String, CaseIterable, Codable {
    case women = "Женское"
    case men = "Мужское"
    case unisex = "Унисекс"
}

enum Brands: String, CaseIterable, Codable {
    case aDerma = "A-Derma"
    case balisan = "BALISAN"
    case bandi = "BANDI"
    case brigitteBottier = "BRIGITTE BOTTIER"
    case bvlgari = "BVLGARI"
    case calvinKlein = "Calvin Klein"
    case davidBeckham = "David Beckham"
    case deepPink = "Deep Pink"
    case eveline = "EVELINE"
    case famirel = "Famirel"
    case harmodea = "Harmodea"
    case iceCurly = "ICE CURLY"
    case loreal = "L'Oreal Paris"
    case mondial = "MONDIAL"
    case nichehouse = "NICHEHOUSE"
    case ogx = "OGX"
    case oneWeek = "one week"
    case rad = "RAD"
    case shamtu = "SHAMTU"
    case shu = "SHU"
    case threeIna = "3INA"
    case tous = "TOUS"
    case vei = "vei"
    case vivienne = "VIVIENNE"
    
    var id: String {
        switch self {
            case .aDerma:
                return "1"
            case .balisan:
                return "2"
            case .bandi:
                return "3"
            case .brigitteBottier:
                return "4"
            case .bvlgari:
                return "5"
            case .calvinKlein:
                return "6"
            case .davidBeckham:
                return "7"
            case .deepPink:
                return "8"
            case .eveline:
                return "9"
            case .famirel:
                return "10"
            case .harmodea:
                return "11"
            case .iceCurly:
                return "12"
            case .loreal:
                return "13"
            case .mondial:
                return "14"
            case .nichehouse:
                return "15"
            case .ogx:
                return "16"
            case .oneWeek:
                return "17"
            case .rad:
                return "18"
            case .shamtu:
                return "19"
            case .shu:
                return "20"
            case .threeIna:
                return "21"
            case .tous:
                return "22"
            case .vei:
                return "23"
            case .vivienne:
                return "24"
        }
    }
}

#Preview {
    NavigationStack {
        BrandsView(viewModel: BrandsViewModel(), searchRoutes: .constant([.productDetails(.placeholder)])) {
            
        }
    }
}
