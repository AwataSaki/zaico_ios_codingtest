//
//  DetailPresenter.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

import Foundation

@MainActor
protocol DetailView: AnyObject {
    func updateInventory(_ inventory: Inventory)
}

class DetailPresenter {
    private let inventoryId: Int
    private(set) var inventory: Inventory?
    private let cellTitles = ["ID", "在庫画像", "タイトル", "数量"]
    weak var view: DetailView?
    
    var numberOfCellTitles: Int {
        cellTitles.count
    }
    
    init(inventoryId: Int, view: DetailView) {
        self.inventoryId = inventoryId
        self.view = view
    }
    
    func viewDidLoad() {
        Task {
            await fetchData()
        }
    }
    
    func cellTitle(for row: Int) -> String {
        cellTitles[row]
    }
    
    private func fetchData() async {
        do {
            let data = try await APIClient.shared.fetchInventorie(id: inventoryId)
            await MainActor.run {
                inventory = data
                view?.updateInventory(data)
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}
