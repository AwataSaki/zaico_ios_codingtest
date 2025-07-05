//
//  InvenrotyListViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

class InvenrotyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private lazy var presenter = InventoryListPresenter(view: self)
    private var inventories: [Inventory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "在庫一覧"
        
        setupTableView()
        setupAddButton()
        
        presenter.viewDidLoad()
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
        presenter.didTapAddButton()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfInventories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let inventory = presenter.inventory(for: indexPath.row)
        cell.configure(leftText: String(inventory.id),
                       rightText: inventory.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}

extension InvenrotyListViewController: InventoryListView {
    func updateInventories(to inventories: [Inventory]) {
        tableView.reloadData()
    }
    
    func transitionToDetail(inventory: Inventory) {
        let detailVC = DetailViewController(id: inventory.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func openAddView() {
        let addInventoryViewController = AddInventoryViewController()
        addInventoryViewController.delegate = self
        present(addInventoryViewController, animated: true)
    }
}

extension InvenrotyListViewController: AddInventoryViewControllerDelegate {
    func addInventoryViewController(_ viewController: AddInventoryViewController, didAddInventory title: String) {
        presenter.didAddInventory(title: title)
    }
}
