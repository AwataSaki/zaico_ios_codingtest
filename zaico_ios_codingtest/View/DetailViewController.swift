//
//  DetailViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let inventoryId: Int
    private lazy var presenter = DetailPresenter(inventoryId: inventoryId, view: self)
    private let tableView = UITableView()
    
    // initメソッドでIDを渡す
    init(id: Int) {
        self.inventoryId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "詳細情報"
        view.backgroundColor = .white
        
        setupTableView()
        
        presenter.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        tableView.register(InventoryImageCell.self, forCellReuseIdentifier: "InventoryImageCell")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfCellTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let cellTitle = presenter.cellTitle(for: indexPath.row)
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            cell.configure(leftText: cellTitle,
                           rightText: String(presenter.inventory?.id ?? 0))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryImageCell", for: indexPath) as! InventoryImageCell
            if let imageURL = presenter.inventory?.itemImage?.url {
                cell.configure(leftText: cellTitle,
                               rightImageURLString: imageURL)
            } else {
                cell.configure(leftText: cellTitle,
                               rightImageURLString: "imageURL")
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            cell.configure(leftText: cellTitle,
                           rightText: presenter.inventory?.title ?? "")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            var quantity = "0"
            if let q = presenter.inventory?.quantity {
                quantity = String(q)
            }
            cell.configure(leftText: cellTitle,
                           rightText: quantity)
            return cell
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: DetailView {
    func updateInventory(_ inventory: Inventory) {
        tableView.reloadData()
    }
}
