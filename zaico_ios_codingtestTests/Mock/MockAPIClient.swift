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
    private let fetchedInventories: [Inventory]
    
    init(successful: Bool = true, fetchedInventories: [Inventory] = []) {
        self.successful = successful
        self.fetchedInventories = fetchedInventories
    }
    
    func fetchInventories() async throws -> [Inventory] {
        guard successful else {
            throw TestError()
        }
        return fetchedInventories
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        guard let id else {
            throw TestError()
        }
        let jsonData = """
            {
                "id": \(id),
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
