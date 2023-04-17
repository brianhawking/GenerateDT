//
//  ViewController.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import UIKit

class DTBuilderViewController: UIViewController {
    
    var rootTile = Tile(type: "", style: "", id: "root", labels: "", actions: "", questions: "", image: "", tiles: [])
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let jsonButton: UIButton = {
        let button = UIButton()
        button.setTitle("Genereate JSON", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tiles"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(jsonButton)
        
        jsonButton.addTarget(self, action: #selector(displayJson), for: .touchUpInside)
    }
    
    @objc private func addButtonPressed() {
        let addChildTileVC = AddChildTileViewController(tile: &rootTile)
        addChildTileVC.delegate = self
        let navController = UINavigationController(rootViewController: addChildTileVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func displayJson() {
        let displayJsonVC = DisplayJsonViewController()
        displayJsonVC.tile = rootTile
        present(displayJsonVC, animated: true)
    }
}

extension DTBuilderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootTile.orderedTiles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && rootTile.orderedTiles()[indexPath.row].id == "root" {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tile = rootTile.orderedTiles()[indexPath.row]
        let level = rootTile.levelOfChildTile(tile)
        
        var spacing = ""
        for _ in 0..<level! {
            spacing += "      "
        }
        cell.textLabel?.text = "\(spacing)\(tile.type) (\(tile.id))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Add button
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            var tile = self.rootTile.orderedTiles()[indexPath.row]
            let addChildVC = AddChildTileViewController(tile: &tile)
            addChildVC.delegate = self
            self.navigationController?.pushViewController(addChildVC, animated: true)
        }
        alertController.addAction(addAction)
        
        // Edit button
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            print("EDIT TILE")
            var tile = self.rootTile.orderedTiles()[indexPath.row]
            let editChildVC = EditTileViewController()
            editChildVC.originalTile = tile
            self.navigationController?.pushViewController(editChildVC, animated: true)
        }
        alertController.addAction(editAction)
        
        // Remove button
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            print("DELETE TILE")
            self.rootTile.removeTile(tile: self.rootTile.orderedTiles()[indexPath.row])
            tableView.reloadData()
        }
        alertController.addAction(removeAction)
        
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("TRYING TO SWAP ROWS")
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension DTBuilderViewController: UITableViewDelegate {
    
}

extension DTBuilderViewController: AddChildTileViewControllerDelegate {
    func didAddChildTile(_ tile: Tile, toParentTile parentTile: inout Tile) {
        if parentTile.id == "root" {
            rootTile = tile
        } else {
            addChildTile(tile, toParentTile: &rootTile, parentTileId: parentTile.id)
        }
        tableView.reloadData()
    }

    private func addChildTile(_ tile: Tile, toParentTile parentTile: inout Tile, parentTileId: String) {
        
        if parentTile.id == parentTileId {
            parentTile.tiles.append(tile)
            return
        }
        for i in 0..<parentTile.tiles.count {
            var childTile = parentTile.tiles[i]
            addChildTile(tile, toParentTile: &childTile, parentTileId: parentTileId)
            parentTile.tiles[i] = childTile
        }
    }
}
