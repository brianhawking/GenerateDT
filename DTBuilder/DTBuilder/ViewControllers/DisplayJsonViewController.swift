//
//  DisplayJsonViewController.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import UIKit

class DisplayJsonViewController: UIViewController {
    
    var tile: Tile = Tile(type: "", style: "", id: "", labels: "", actions: "", questions: "", image: "", tiles: [])
    
//    let stackView = UIStackView()
//    let textView = UITextView()
//    let jsonButton = UIButton()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let jsonButton: UIButton = {
        let button = UIButton()
        button.setTitle("Copy JSON", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        jsonButton.addTarget(self, action: #selector(copyJsonPressed), for: .touchUpInside)
        generateJson()
    }
    
    func configureUI() {
        view.addSubview(stackView)
        // Set up constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(jsonButton)
        
    }
    
    @objc func generateJson() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(tile)
            if let jsonString = String(data: data, encoding: .utf8) {
                textView.text = jsonString
            }
        } catch {
            print("Error encoding tile: \(error.localizedDescription)")
        }
    }
    
    @objc func copyJsonPressed() {
        showCheckmark()
    }
    
    func showCheckmark() {
        // Create checkmark image view
        let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkImageView.tintColor = .systemBlue
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        // Add checkmark image view to view
        view.addSubview(checkmarkImageView)

        // Center checkmark image view horizontally and vertically in the view
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 100),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Set initial alpha of checkmark image view to 0
        checkmarkImageView.alpha = 0

        // Animate checkmark image view
        UIView.animate(withDuration: 0.5, animations: {
            checkmarkImageView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: 0.3, delay: 1, animations: {
                checkmarkImageView.alpha = 0
            }) { (finished) in
                checkmarkImageView.removeFromSuperview()
            }
        }

    }

}
