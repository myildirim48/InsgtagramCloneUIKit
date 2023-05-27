//
//  RegistrationController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit
class RegistrationController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysTemplate) , for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordField = CustomTextField(placeholder: "Password", isSecure: true)
    private let fullnameField = CustomTextField(placeholder: "Fullname")
    private let usernameField = CustomTextField(placeholder: "Username")

    private let registerButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
        
    private let gotoLoginButton = TextButton(firstPart: "Already have an account?", lastPart: "Log In")
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addActions()
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(addImageButton)
        addImageButton.centerX(inView: view)
        addImageButton.setDimensions(height: 140, width: 140)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordField, fullnameField, usernameField, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(gotoLoginButton)
        gotoLoginButton.centerX(inView: view)
        gotoLoginButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func addActions() {
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        gotoLoginButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordField {
            viewModel.password = sender.text
        } else if sender == fullnameField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        updateForm()
    }
}
extension RegistrationController: FormViewModel {
    func updateForm() {
        
        registerButton.backgroundColor = viewModel.buttonBackgroundColor
        registerButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        registerButton.isEnabled = viewModel.formIsValid
    }
}
