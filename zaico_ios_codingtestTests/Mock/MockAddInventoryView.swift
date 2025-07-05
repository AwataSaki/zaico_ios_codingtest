//
//  MockAddInventoryView.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

@testable import zaico_ios_codingtest

class MockAddInventoryView: AddInventoryView {
    private(set) var notifyAddingInventoryCalled: Bool = false
    private(set) var dismissCalled: Bool = false
    
    func notifyAddingInventory(title: String) {
        notifyAddingInventoryCalled = true
    }
    
    func dismiss() {
        dismissCalled = true
    }
}
