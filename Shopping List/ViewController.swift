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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
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
    
    @objc func clearItems() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }


}

