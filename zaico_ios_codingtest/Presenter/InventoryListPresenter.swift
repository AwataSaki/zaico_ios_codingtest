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
    private let apiClient: any APIClientProtocol
    
    var numberOfInventories: Int {
        inventories.count
    }
    
    init(view: InventoryListView, apiClient: any APIClientProtocol = APIClient.shared) {
        self.view = view
        self.apiClient = apiClient
    }
    
    @MainActor @discardableResult
    func viewDidLoad() -> Task<Void, Never> {
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
    
    @discardableResult
    func didAddInventory(title: String) -> Task<Void, Never> {
        Task {
            await fetchData()
        }
    }
    
    private func fetchData() async {
        do {
            let data = try await apiClient.fetchInventories()
            inventories = data
            await view?.updateInventories(to: data)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
 }
