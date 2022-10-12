//
//  ViewController.swift
//  Password selection
//
//  Created by Артем Галай on 10.10.22.
//

import UIKit

final class ViewController: UIViewController {

    var isCycleRunning = true
    var isStartBrute = false
    var isSuccess = false

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
        button.addTarget(self, action: #selector(buttonStart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var changeBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "change")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonChangeBackground), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 15
        textField.attributedPlaceholder = NSAttributedString(string: "password",
                                                             attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo,
                                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var guessedPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stop")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonStop), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    //MARK: - Setup

    private func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(changeBackgroundButton)
        view.addSubview(setupButton)
        view.addSubview(passwordTextField)
        view.addSubview(guessedPasswordLabel)
        view.addSubview(activityIndicatorView)
        view.addSubview(stopButton)
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
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            passwordTextField.widthAnchor.constraint(equalToConstant: 120),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            guessedPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            guessedPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicatorView.topAnchor.constraint(equalTo: guessedPasswordLabel.bottomAnchor, constant: 10),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 40),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 40),

            stopButton.centerYAnchor.constraint(equalTo: setupButton.centerYAnchor),
            stopButton.leadingAnchor.constraint(equalTo: setupButton.trailingAnchor, constant: 0),
            stopButton.widthAnchor.constraint(equalToConstant: 120),
            stopButton.heightAnchor.constraint(equalToConstant:120)
        ])
    }

    //MARK: - Actions

    @objc func buttonChangeBackground() {
        isDoor.toggle()
    }

    @objc func buttonStart() {
        guard let passwordEntered = passwordTextField.text, !passwordEntered.isEmpty, !isStartBrute else {
            return
        }
        startAnimationForce()
        bruteForce(passwordToUnlock: passwordEntered, completion: { [weak self] text in
            self?.stopAnimationForce()
            self?.guessedPasswordLabel.text = text
            self?.isCycleRunning = true
            self?.isStartBrute = false
        })
        isSuccess = false
    }

    @objc func buttonStop() {
        isCycleRunning = false
    }

    func startAnimationForce() {
        self.activityIndicatorView.startAnimating()
        self.stopButton.isHidden = false
    }

    func stopAnimationForce() {
        self.passwordTextField.isSecureTextEntry = false
        self.activityIndicatorView.stopAnimating()
        self.stopButton.isHidden = true
    }

    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void?) {

        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password: String = ""
        isStartBrute = true

        let queue = DispatchQueue(label: "queue", qos: .background)
        queue.async {
            while self.isCycleRunning == true {
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                DispatchQueue.main.async {
                    self.guessedPasswordLabel.text = password
                }
                if password == passwordToUnlock {
                    self.isSuccess = true
                    self.isCycleRunning = false
                }
            }
            DispatchQueue.main.async { [weak self] in
                completion(self?.isSuccess == true ? password : passwordToUnlock)
            }
        }
    }
}
