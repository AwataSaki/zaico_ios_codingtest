//
//  AddInventoryPresenterTests.swift
//  zaico_ios_codingtestTests
//
//  Created by ryo hirota on 2025/03/11.
//

import Testing
@testable import zaico_ios_codingtest

@MainActor
struct AddInventoryPresenterTests {
    @Test("在庫が追加されたら画面が閉じる")
    func dismissViewWhenInventoryIsAdded() async throws {
        let view = MockAddInventoryView()
        let apiClient = MockAPIClient()
        let presenter = AddInventoryPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(!view.notifyAddingInventoryCalled)
        #expect(!view.dismissCalled)
        
        await presenter.didTapAddButton(text: "").value
        #expect(view.notifyAddingInventoryCalled, "追加が通知される")
        #expect(view.dismissCalled, "画面が閉じる")
    }
    
    @Test("追加に失敗した場合、画面は閉じない")
    func notDismissWhenAddingInventoryFails() async throws {
        let view = MockAddInventoryView()
        let apiClient = MockAPIClient(successful: false)
        let presenter = AddInventoryPresenter(view: view, apiClient: apiClient)
        
        // 初期値の確認
        #expect(!view.notifyAddingInventoryCalled)
        #expect(!view.dismissCalled)
        
        await presenter.didTapAddButton(text: "").value
        #expect(!view.notifyAddingInventoryCalled, "追加が通知されない")
        #expect(!view.dismissCalled, "画面が閉じない")
    }
}
