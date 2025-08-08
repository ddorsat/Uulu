//
//  MainTabBarView.swift
//  Uulu
//
//  Created by ddorsat on 24.06.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tabs = .feed
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(Tabs.feed.rawValue, systemImage: Tabs.feed.icon, value: .feed) {
                FeedView(selectedTab: $selectedTab)
            }
            
            Tab(Tabs.catalog.rawValue, systemImage: Tabs.catalog.icon, value: .catalog) {
                CatalogView(selectedTab: $selectedTab)
            }
            
            Tab(Tabs.favorites.rawValue, systemImage: Tabs.favorites.icon, value: .favorites) {
                FavoritesView(selectedTab: $selectedTab)
            }
            
            Tab(Tabs.profile.rawValue, systemImage: Tabs.profile.icon, value: .profile) {
                AuthView(selectedTab: $selectedTab)
            }
            
            Tab(value: .search, role: .search) {
                SearchView(selectedTab: $selectedTab)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

enum Tabs: String {
    case feed = "Главное"
    case catalog = "Каталог"
    case favorites = "Любимое"
    case profile = "Профиль"
    case search
    
    var icon: String {
        switch self {
            case .feed:
                return "house"
            case .catalog:
                return "tag.fill"
            case .favorites:
                return "heart"
            case .profile:
                return "person"
            case .search:
                return "magnifyingglass"
        }
    }
}

#Preview {
    MainTabView()
}
