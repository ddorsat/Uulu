//
//  NoveltyViewModel.swift
//  Uulu
//
//  Created by ddorsat on 09.07.2025.
//

import Foundation
import FirebaseFirestore

final class NoveltyViewModel: ProductsViewModel {
    init() {
        super.init(field: "is_novelty", isEqualToBool: true)
    }
}

