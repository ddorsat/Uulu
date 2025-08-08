//
//  TrendingViewModel.swift
//  Uulu
//
//  Created by ddorsat on 10.07.2025.
//

import Foundation
import FirebaseFirestore

final class TrendingViewModel: ProductsViewModel {
    init() {
        super.init(field: "is_trending", isEqualToBool: true)
    }
}

