//
//  AddTileViewController.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import UIKit

enum TextFieldTags {
    case tileType
    case styleType
    
    func getTag() -> Int {
        switch self {
        case .tileType: return 1
        case .styleType: return 2
        }
    }
}

protocol AddChildTileViewControllerDelegate: AnyObject {
    func didAddChildTile(_ tile: Tile, toParentTile parentTile: inout Tile)
}

class AddChildTileViewController: UIViewController {
    
    weak var delegate: AddChildTileViewControllerDelegate?
    var selectedTile: Tile
    
    init(tile: inout Tile) {
        self.selectedTile = tile
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let typeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter type"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = TextFieldTags.tileType.getTag()
        return textField
    }()
    
    private let styleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter style"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = TextFieldTags.styleType.getTag()
        return textField
    }()
    
    let actionsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Actions"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let labelsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Labels"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let optionsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Options"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addChildTileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Tile", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        typeTextField.addTarget(self, action: #selector(textFieldTapped), for: .touchDown)
        styleTextField.addTarget(self, action: #selector(textFieldTapped), for: .touchDown)
    }
    
    @objc private func textFieldTapped(sender: UITextField) {
        let tableViewController = SelectFromTableViewController()
        
        switch sender.tag {
        case TextFieldTags.tileType.getTag():
            tableViewController.textField = typeTextField
            tableViewController.items = TileType.asArray()
        case TextFieldTags.styleType.getTag():
            tableViewController.textField = styleTextField
            tableViewController.items = TileStyle.asArray()
        default:
            break
        }
        
        let navigationController = UINavigationController(rootViewController: tableViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [typeTextField, styleTextField, idTextField, actionsTextField, labelsTextField, optionsTextField, addChildTileButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addChildTileButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        addChildTileButton.addTarget(self, action: #selector(addChildTileButtonPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addChildTileButtonPressed() {
        guard let id = idTextField.text, !id.isEmpty, let type = typeTextField.text, !type.isEmpty, let actions = actionsTextField.text, let labels = labelsTextField.text, let options = optionsTextField.text, let style = styleTextField.text, !style.isEmpty else {
            return
        }
        
        let childTile = Tile(type: type, style: style, id: id, labels: "", actions: "", questions: "", image: "", tiles: [])
        delegate?.didAddChildTile(childTile, toParentTile: &selectedTile)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
