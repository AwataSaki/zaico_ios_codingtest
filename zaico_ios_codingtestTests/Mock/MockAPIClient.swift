//
//  MockAPIClient.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

import Foundation
@testable import zaico_ios_codingtest

class MockAPIClient: APIClientProtocol {
    private let successful: Bool
    
    init(successful: Bool = true) {
        self.successful = successful
    }
    
    func fetchInventories() async throws -> [Inventory] {
        []
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        let jsonData = """
            {
                "id": 1,
                "title": "タイトル"
            }
            """.data(using: .utf8)!
        return try JSONDecoder().decode(Inventory.self, from: jsonData)
    }
    
    func addInventry(title: String) async throws {
        if !successful {
            throw TestError()
        }
    }
}
