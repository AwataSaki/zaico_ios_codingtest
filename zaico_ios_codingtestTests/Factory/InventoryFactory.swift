//
//  InventoryFactory.swift
//  zaico_ios_codingtestTests
//
//  Created by awata saki on 2025/07/05.
//

import Foundation
@testable import zaico_ios_codingtest

struct InventoryFactory {
    static func create(id: Int) -> Inventory {
        let jsonData = """
            {
                "id": \(id),
                "title": "タイトル\(id)"
            }
            """.data(using: .utf8)!
        return try! JSONDecoder().decode(Inventory.self, from: jsonData)
    }
    
    static func createList(count: Int) -> [Inventory] {
        (1...count).map(create)
    }
}
