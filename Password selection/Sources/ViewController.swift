//
//  ViewController.swift
//  Password selection
//
//  Created by Артем Галай on 10.10.22.
//

import UIKit

final class PasswordViewController: UIViewController {

    private var isCycleRunning = true
    private var isStartBrute = false
    private var isSuccess = false

    //MARK: - UIElements

    private lazy var backgroundView: UIImageView = {
        let imageViewBackground = UIImageView(frame: UIScreen.main.bounds)
        imageViewBackground.image = MetricPasswordViewController.backgroundViewImage
        return imageViewBackground
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = MetricPasswordViewController.textFieldLayerCornerRadius
        textField.attributedPlaceholder = NSAttributedString(string: "password",
                                                             attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo,
                                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.systemIndigo.cgColor
        textField.layer.borderWidth = MetricPasswordViewController.textFieldLayerBorderWidth
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var guessedPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: MetricPasswordViewController.labelFontSize, weight: .bold)
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

    private func makeButton(image: UIImage, action: Selector, isHidden: Bool) -> UIButton {
        let button = UIButton()
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isHidden = isHidden
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private lazy var startButton = makeButton(image: MetricPasswordViewController.startButtonImage,
                                              action: #selector(buttonStart),
                                              isHidden: false)
    private lazy var changeBackgroundButton = makeButton(image: MetricPasswordViewController.changeBackgroundButtonImage,
                                                         action: #selector(buttonChangeBackground),
                                                         isHidden: false)
    private lazy var stopButton = makeButton(image: MetricPasswordViewController.stopButtonImage,
                                             action: #selector(buttonStop),
                                             isHidden: true)

    private var isDoor: Bool = true {
        didSet {
            backgroundView.image = isDoor ? MetricPasswordViewController.backgroundViewImage: MetricPasswordViewController.newBackgroundViewImage
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
        view.addSubview(startButton)
        view.addSubview(passwordTextField)
        view.addSubview(guessedPasswordLabel)
        view.addSubview(activityIndicatorView)
        view.addSubview(stopButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([

            changeBackgroundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeBackgroundButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                           constant: MetricPasswordViewController.changeBackgroundButtonBottomAnchorConstraint),
            changeBackgroundButton.widthAnchor.constraint(equalToConstant: MetricPasswordViewController.changeBackgroundButtonWidthAnchorConstraint),
            changeBackgroundButton.heightAnchor.constraint(equalToConstant: MetricPasswordViewController.changeBackgroundButtonHeightAnchorConstraint),

            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: MetricPasswordViewController.startButtonTopAnchorConstraint),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: MetricPasswordViewController.startButtonWidthAnchorConstraint),
            startButton.heightAnchor.constraint(equalToConstant: MetricPasswordViewController.startButtonHeightAnchorConstraint),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                   constant: MetricPasswordViewController.passwordTextFieldTopAnchorConstraint),
            passwordTextField.widthAnchor.constraint(equalToConstant: MetricPasswordViewController.passwordTextFieldWidthAnchorConstraint),
            passwordTextField.heightAnchor.constraint(equalToConstant: MetricPasswordViewController.passwordTextFieldHeightAnchorConstraint),

            guessedPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                      constant: MetricPasswordViewController.guessedPasswordLabelTopAnchorConstraint),
            guessedPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicatorView.topAnchor.constraint(equalTo: guessedPasswordLabel.bottomAnchor,
                                                       constant: MetricPasswordViewController.activityIndicatorViewTopAnchorConstraint),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: MetricPasswordViewController.activityIndicatorViewHeightAnchorConstraint),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: MetricPasswordViewController.activityIndicatorViewWidthAnchorConstraint),

            stopButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            stopButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: MetricPasswordViewController.stopButtonWidthAnchorConstraint),
            stopButton.heightAnchor.constraint(equalToConstant: MetricPasswordViewController.stopButtonHeightAnchorConstraint)
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

    private func startAnimationForce() {
        activityIndicatorView.startAnimating()
        stopButton.isHidden = false
    }

    private func stopAnimationForce() {
        passwordTextField.isSecureTextEntry = false
        activityIndicatorView.stopAnimating()
        stopButton.isHidden = true
    }

    private func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> ()) {

        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        isStartBrute = true

        let queue = DispatchQueue(label: "queue", qos: .background)
        queue.async {
            while self.isCycleRunning {
                password = generateBruteForce(password, fromArray: allowedCharacters)
                DispatchQueue.main.async {
                    self.guessedPasswordLabel.text = password
                }
                if password == passwordToUnlock {
                    self.isSuccess = true
                    self.isCycleRunning = false
                }
            }
            DispatchQueue.main.async { [weak self] in
                completion(self?.isSuccess ?? false ? password : passwordToUnlock)
            }
        }
    }
}
