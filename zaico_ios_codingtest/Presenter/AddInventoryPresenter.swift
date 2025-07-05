//
//  AddInventoryPresenter.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

import Foundation

@MainActor
protocol AddInventoryView: AnyObject {
    func notifyAddingInventory(title: String)
    func dismiss()
}

class AddInventoryPresenter {
    weak var view: AddInventoryView?
    private let apiClient: any APIClientProtocol
    
    init(view: AddInventoryView, apiClient: any APIClientProtocol = APIClient.shared) {
        self.view = view
        self.apiClient = apiClient
    }
    
    @MainActor @discardableResult
    func didTapAddButton(text: String) -> Task<Void, Never> {
        Task {
            do {
                try await addInventory(title: text)
                view?.notifyAddingInventory(title: text)
                view?.dismiss()
            } catch {}
        }
    }
    
    private func addInventory(title: String) async throws {
        do {
            try await apiClient.addInventry(title: title)
        } catch {
            print("Error adding data: \(error.localizedDescription)")
            throw error
        }
    }
}
