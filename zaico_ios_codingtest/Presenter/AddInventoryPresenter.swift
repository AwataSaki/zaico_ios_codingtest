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
    
    init(view: AddInventoryView) {
        self.view = view
    }
    
    func didTapAddButton(text: String) {
        Task {
            await addInventory(title: text)
            await view?.notifyAddingInventory(title: text)
            await view?.dismiss()
        }
    }
    
    private func addInventory(title: String) async {
        do {
            try await APIClient.shared.addInventry(title: title)
        } catch {
            print("Error adding data: \(error.localizedDescription)")
        }
    }
}
