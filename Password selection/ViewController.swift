//
//  ViewController.swift
//  Password selection
//
//  Created by Артем Галай on 10.10.22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - UIElements

    private let backgroundView: UIImageView = {
        let imageViewBackground = UIImageView(frame: UIScreen.main.bounds)
        imageViewBackground.image = UIImage(named: "background")
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        return imageViewBackground
    }()

    private lazy var setupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "password")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var changeBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "change")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = .purple
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var isDoor: Bool = true {
        didSet {
            if isDoor {
                backgroundView.image = UIImage(named: "background")
            } else {
                backgroundView.image = UIImage(named: "background2")
            }
        }
    }

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(changeBackgroundButton)
        view.addSubview(setupButton)
        view.addSubview(passwordTextField)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            changeBackgroundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeBackgroundButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            changeBackgroundButton.widthAnchor.constraint(equalToConstant: 300),
            changeBackgroundButton.heightAnchor.constraint(equalToConstant: 140),

            setupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 310),
            setupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupButton.widthAnchor.constraint(equalToConstant: 120),
            setupButton.heightAnchor.constraint(equalToConstant: 120),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func buttonTapped() {
        isDoor.toggle()
    }
}
