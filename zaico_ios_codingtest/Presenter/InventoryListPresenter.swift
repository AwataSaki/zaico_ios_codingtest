//
//  InventoryListPresenter.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

import Foundation

@MainActor
protocol InventoryListView: AnyObject {
    func updateInventories(to inventories: [Inventory])
    func transitionToDetail(inventory: Inventory)
    func openAddView()
}

class InventoryListPresenter {
    private var inventories: [Inventory] = []
    weak var view: InventoryListView?
    
    var numberOfInventories: Int {
        inventories.count
    }
    
    init(view: InventoryListView) {
        self.view = view
    }
    
    func viewDidLoad() {
        Task {
            await fetchData()
        }
    }
    
    func inventory(for row: Int) -> Inventory {
        inventories[row]
    }
    
    @MainActor
    func didSelectRow(at indexPath: IndexPath) {
        let inventory = inventory(for: indexPath.row)
        view?.transitionToDetail(inventory: inventory)
    }
    
    @MainActor
    func didTapAddButton() {
        view?.openAddView()
    }
    
    func didAddInventory(title: String) {
        Task {
            await fetchData()
        }
    }
    
    private func fetchData() async {
        do {
            let data = try await APIClient.shared.fetchInventories()
            inventories = data
            await view?.updateInventories(to: data)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
 }
