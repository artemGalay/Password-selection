//
//  ViewController.swift
//  Password selection
//
//  Created by Артем Галай on 10.10.22.
//

import UIKit

final class ViewController: UIViewController {

    //MARK: - UIElements

    private lazy var backgroundView: UIImageView = {
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
        textField.attributedPlaceholder = NSAttributedString(string: "password",
                                                             attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var guessedPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Your password: "
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.addSubview(guessedPasswordLabel)
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
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            passwordTextField.widthAnchor.constraint(equalToConstant: 150),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),

            guessedPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            guessedPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func buttonTapped() {
        isDoor.toggle()
    }
}
