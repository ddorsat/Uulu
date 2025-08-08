//
//  FeedViewModel.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var feedRoutes: [FeedRoutes] = []
    @Published private(set) var videoViewModel = VideoViewModel()
    @Published private(set) var noveltyViewModel = NoveltyViewModel()
    @Published private(set) var perfumesViewModel = PerfumesViewModel()
    @Published private(set) var trendingViewModel = TrendingViewModel()
    @Published private(set) var basketViewModel = BasketViewModel()
    @Published private(set) var authViewModel = AuthViewModel()
    
    private var cancellabes = Set<AnyCancellable>()
    
    init() {
        listenToVMs()
    }
    
    deinit {
        cancellabes.removeAll()
    }
    
    func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.videoViewModel.fetchProducts()
            }
            group.addTask {
                await self.noveltyViewModel.fetchProducts()
            }
            group.addTask {
                await self.perfumesViewModel.fetchProducts()
            }
            group.addTask {
                await self.trendingViewModel.fetchProducts()
            }
            group.addTask {
                await self.basketViewModel.listenToBasket()
            }
            group.addTask {
                await self.authViewModel.listenToAuthState()
            }
        }
    }
    
    private func listenToVMs() {
        videoViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
        
        noveltyViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
        
        perfumesViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
        
        trendingViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
        
        basketViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
        
        authViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellabes)
    }
}

enum FeedRoutes: Hashable {
    case video
    case perfumes
    case novelty
    case trending
    case productDetails(_ product: ProductModel)
    case basket
    case basketOrder
    case basketOrderComplete
}
