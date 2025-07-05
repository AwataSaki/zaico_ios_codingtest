//
//  MockDetailView.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

@testable import zaico_ios_codingtest

class MockDetailView: DetailView {
    private(set) var updateInventoryCalled: Bool = false
    
    func updateInventory(_ inventory: Inventory) {
        updateInventoryCalled = true
    }
}
