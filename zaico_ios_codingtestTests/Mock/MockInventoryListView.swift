//
//  MockInventoryListView.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

@testable import zaico_ios_codingtest

class MockInventoryListView: InventoryListView {
    private(set) var updateInventoriesCalled: Bool = false
    private(set) var passedInventoryTitle: Inventory?
    private(set) var openAddViewCalled: Bool = false
    
    func updateInventories(to inventories: [Inventory]) {
        updateInventoriesCalled = true
    }
    
    func transitionToDetail(inventory: Inventory) {
        passedInventoryTitle = inventory
    }
    
    func openAddView() {
        openAddViewCalled = true
    }
}
