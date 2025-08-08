//
//  FeedViewModel.swift
//  Uulu
//
//  Created by ddorsat on 01.07.2025.
//

import Foundation
import FirebaseFirestore

@MainActor
final class PerfumesViewModel: ProductsViewModel {
    init() {
        super.init(field: "category", isEqualTo: "Парфюмерия")
    }
}
