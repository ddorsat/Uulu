//
//  ProductsService.swift
//  Uulu
//
//  Created by ddorsat on 03.07.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ProductsService {
    static let shared = ProductsService()

    func uploadProduct(_ product: ProductModel) async {
        let ref = FBConstants.productsRef.document(product.id)
        
        do {
            try await FBService.upload(ref: ref, model: product)
        } catch {
            print("Failed to upload product - \(product.id)")
        }
    }
    
    func fetchProduct(_ productID: String) async -> ProductModel? {
        do {
            return try await FBConstants.productsRef.document(productID).getDocument(as: ProductModel.self)
        } catch {
            print("Failed to fetch product - \(productID)")
            return nil
        }
    }
    
    func listenToProduct(id: String, completion: @escaping (ProductModel) -> Void) -> ListenerRegistration {
        FBConstants.productsRef.document(id).addSnapshotListener { snapshot, _ in
            guard let product = try? snapshot?.data(as: ProductModel.self) else { return }
            completion(product)
        }
    }
    
    func fetchProducts(descending: Bool?, count: Int, field: String?, isEqualTo: String?, isEqualToBool: Bool?, searchText: String?, lastDocument: DocumentSnapshot?) async throws -> ([ProductModel], DocumentSnapshot?) {
        var query: Query = FBConstants.productsRef

        if let field, let isEqualTo {
            query = query.whereField(field, isEqualTo: isEqualTo)
        }

        if let field, let isEqualToBool {
            query = query.whereField(field, isEqualTo: isEqualToBool)
        }

        if let searchText, !searchText.isEmpty {
            query = query
                .whereField("name", isGreaterThanOrEqualTo: searchText)
                .whereField("name", isLessThan: searchText + "\u{f8ff}")
        }

        if let descending {
            query = query.order(by: "min_price", descending: descending)
        }

        return try await query
            .limit(to: count)
            .startOptionally(after: lastDocument)
            .getDocumentsWithLastDocument(as: ProductModel.self)
    }
}
