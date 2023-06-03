//
//  LoginController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationCompleted()
}

class LoginController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?

    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white") )
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordField = CustomTextField(placeholder: "Password", isSecure: true)
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    private let forgotPasswordButton = TextButton(firstPart: "For got your password?", lastPart: "Get help signing in.")
    
    private let dontHaveAccountButton = TextButton(firstPart: "Dont have an account?", lastPart: "Sign Up")
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addActions()
    }
    
    //MARK: - Helpers
    
    func addActions() {
        authButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        updateForm()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordField, authButton, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    //MARK: - Actions
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordField.text else { return }
        
        showLoader(true, text: "User is logging in...")

        
        AuthService.logUserIn(email: email, password: password) { authResult, error in
            if let error {
                print("DEEBUG: Error while log user in, \(error.localizedDescription)")
                return
            }
            self.showLoader(false)
            self.delegate?.authenticationCompleted()
//            self.dismiss(animated: true)
        }
    }
    
    @objc func handleForgotPassword() {
        let controller = ResetPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRegister() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
}
//MARK: -  FormviewModel Delegate
extension LoginController: FormViewModel {
    func updateForm() {
        authButton.backgroundColor = viewModel.buttonBackgroundColor
        authButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        authButton.isEnabled = viewModel.formIsValid
    }
}
//MARK: - ResetPasswordDelegate
extension LoginController: ResetPasswordControllerDelegate {
    func didSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success",
                    message: "We sent a link to your email to reset your password.")
    }
}
