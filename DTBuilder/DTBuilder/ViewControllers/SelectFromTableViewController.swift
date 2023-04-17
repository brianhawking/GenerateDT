//
//  SelectFromTableViewController.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import UIKit

class SelectFromTableViewController: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = items[indexPath.row]
        dismiss(animated: true, completion: nil)
    }
}

class MyTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
