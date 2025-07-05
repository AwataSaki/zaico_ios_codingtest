//
//  AddInventoryViewController.swift
//  zaico_ios_codingtest
//
//  Created by awata saki on 2025/07/05.
//

import UIKit

protocol AddInventoryViewControllerDelegate: AnyObject {
    func addInventoryViewController(_ viewController: AddInventoryViewController, didAddInventory title: String)
}

class AddInventoryViewController: UIViewController {
    private lazy var presenter = AddInventoryPresenter(view: self)
    private let textField = UITextField()
    private let button = UIButton()
    
    weak var delegate: AddInventoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 20),
        ])
        
        button.setTitle("追加する", for: .normal)
        button.configuration = .plain()
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        guard let text = textField.text else { return }
        presenter.didTapAddButton(text: text)
    }
}

extension AddInventoryViewController: AddInventoryView {
    func notifyAddingInventory(title: String) {
        delegate?.addInventoryViewController(self, didAddInventory: title)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
