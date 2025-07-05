//
//  InvenrotyListViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

class InvenrotyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var inventories: [Inventory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "在庫一覧"
        
        setupTableView()
        setupAddButton()
        
        Task {
            await fetchData()
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(
            title: "＋",
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let addInventoryViewController = AddInventoryViewController()
        addInventoryViewController.delegate = self
        present(addInventoryViewController, animated: true)
    }
    
    private func fetchData() async {
        do {
            let data = try await APIClient.shared.fetchInventories()
            await MainActor.run {
                inventories = data
                tableView.reloadData()
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.configure(leftText: String(inventories[indexPath.row].id),
                       rightText: inventories[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(id: inventories[indexPath.row].id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension InvenrotyListViewController: AddInventoryViewControllerDelegate {
    func addInventoryViewController(_ viewController: AddInventoryViewController, didAddInventory title: String) {
        dismiss(animated: true)
        refresh()
    }
    
    private func refresh() {
        Task {
            await fetchData()
        }
    }
}
