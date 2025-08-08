//
//  Extensions.swift
//  Uulu
//
//  Created by ddorsat on 20.07.2025.
//

import Foundation
import UIKit
import FirebaseFirestore

extension UIDevice {
    static var ProMax: Bool {
        UIScreen.main.bounds.width >= 430
    }
}

extension Query {
    func getDocumentsWithLastDocument<T>(as type: T.Type) async throws -> ([T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        let items = try snapshot.documents.map { try $0.data(as: T.self) }
        return (items, snapshot.documents.last)
    }
    
    func startOptionally(after lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
}

extension Date {
    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM yyyy в HH:mm"
        return dateFormatter.string(from: self)
    }
}

