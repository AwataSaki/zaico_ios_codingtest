//
//  DetailPresenterTests.swift
//  zaico_ios_codingtestTests
//
//  Created by awata saki on 2025/07/05.
//

import Testing
@testable import zaico_ios_codingtest

@MainActor
struct DetailPresenterTests {
    @Test("viewDidLoadでデータが更新される")
    func fetchDetailOnViewDidLoad() async throws {
        let view = MockDetailView()
        let apiClient = MockAPIClient()
        let presenter = DetailPresenter(
            inventoryId: 1,
            view: view,
            apiClient: apiClient
        )
        
        // 初期値の確認
        #expect(presenter.inventory == nil)
        #expect(!view.updateInventoryCalled)
        
        await presenter.viewDidLoad().value
        #expect(presenter.inventory != nil, "データが更新される")
        #expect(view.updateInventoryCalled, "更新が通知される")
    }
}
