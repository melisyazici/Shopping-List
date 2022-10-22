//
//  ViewController.swift
//  Shopping List
//
//  Created by Melis Yazıcı on 22.10.22.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearItems))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addTapped() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let addAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.addItem(item)
        }
        ac.addAction(addAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func addItem(_ item: String) {
        if item.isEmpty {
            let ac = UIAlertController(title: "Add some item", message: "You didn't add item", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        } else if itemAlreadyExist(item: item) {
            let ac = UIAlertController(title: "Item present", message: "\"\(item)\" is already on your shopping list", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic) // animate the new cell appearing
    }
    
    func itemAlreadyExist(item: String) -> Bool {
        return shoppingList.contains(where: {
            $0.compare(item, options: .caseInsensitive) == .orderedSame
        })
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        if list.isEmpty {
            let ac = UIAlertController(title: "No items to share", message: "You have no item", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(vc, animated: true)
    }
    
    @objc func clearItems() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }


}

