//
//  InventoryListPresenterTests.swift
//  zaico_ios_codingtestTests
//
//  Created by awata saki on 2025/07/05.
//

import Testing
@testable import zaico_ios_codingtest
import Foundation

@MainActor
struct InventoryListPresenterTests {
    @Test("viewDidLoadで在庫が更新される")
    func fetchInventoriesOnViewDidLoad() async {
        let view = MockInventoryListView()
        let jsonData = """
            [
                { "id": 1, "title": "在庫1" },
                { "id": 2, "title": "在庫2" }
            ]
            """.data(using: .utf8)!
        let inventories = try! JSONDecoder().decode([Inventory].self, from: jsonData)
        let apiClient = MockAPIClient(fetchedInventories: inventories)
        let presenter = InventoryListPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(presenter.numberOfInventories == 0)
        #expect(!view.updateInventoriesCalled)
        
        await presenter.viewDidLoad().value
        #expect(presenter.numberOfInventories == 2, "在庫数が更新される")
        #expect(view.updateInventoriesCalled, "在庫の更新が通知される")
    }
    
    @Test("在庫の取得に失敗した場合、viewDidLoadで在庫が更新されない")
    func notUpdateInventoriesWhenFetchingFails() async {
        let view = MockInventoryListView()
        let jsonData = """
            [
                { "id": 1, "title": "在庫1" },
                { "id": 2, "title": "在庫2" }
            ]
            """.data(using: .utf8)!
        let inventories = try! JSONDecoder().decode([Inventory].self, from: jsonData)
        let apiClient = MockAPIClient(successful: false, fetchedInventories: inventories)
        let presenter = InventoryListPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(presenter.numberOfInventories == 0)
        #expect(!view.updateInventoriesCalled)
        
        await presenter.viewDidLoad().value
        #expect(presenter.numberOfInventories == 0, "在庫数が更新されない")
        #expect(!view.updateInventoriesCalled, "在庫の更新が通知されない")
    }
    
    @Test("在庫を選択して詳細へ遷移する")
    func transitionToDetailOnSelectInventory() async {
        let view = MockInventoryListView()
        let jsonData = """
            [
                { "id": 1, "title": "在庫1" },
                { "id": 2, "title": "在庫2" }
            ]
            """.data(using: .utf8)!
        let inventories = try! JSONDecoder().decode([Inventory].self, from: jsonData)
        let apiClient = MockAPIClient(fetchedInventories: inventories)
        let presenter = InventoryListPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(view.passedInventoryTitle == nil)
        
        await presenter.viewDidLoad().value
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        #expect(view.passedInventoryTitle?.id == 1, "詳細へ遷移する")
    }
    
    @Test("追加ボタンをタップして在庫追加画面が開く")
    func openAddViewOnTapAddButton() {
        let view = MockInventoryListView()
        let presenter = InventoryListPresenter(view: view, apiClient: MockAPIClient())
        
        // 初期値の確認
        #expect(!view.openAddViewCalled)
        
        presenter.didTapAddButton()
        #expect(view.openAddViewCalled, "在庫追加画面が開く")
    }
    
    @Test("在庫追加時に在庫が更新される")
    func reloadInventoriesOnInventoryIsAdded() async {
        let view = MockInventoryListView()
        let jsonData = """
            [
                { "id": 1, "title": "在庫1" },
                { "id": 2, "title": "在庫2" }
            ]
            """.data(using: .utf8)!
        let inventories = try! JSONDecoder().decode([Inventory].self, from: jsonData)
        let apiClient = MockAPIClient(fetchedInventories: inventories)
        let presenter = InventoryListPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(presenter.numberOfInventories == 0)
        #expect(!view.updateInventoriesCalled)
        
        await presenter.didAddInventory(title: "").value
        #expect(presenter.numberOfInventories == 2, "在庫数が更新される")
        #expect(view.updateInventoriesCalled, "在庫の更新が通知される")
    }
}
