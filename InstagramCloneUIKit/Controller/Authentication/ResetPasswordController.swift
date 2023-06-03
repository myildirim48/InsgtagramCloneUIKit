//
//  ResetPasswordController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func didSendResetPasswordLink(_ controller: ResetPasswordController )
}
class ResetPasswordController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    private let emailField = CustomTextField(placeholder: "Email")
    private let iconImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureGradientLayer()

        emailField.addTarget(self, action: #selector(textDidchange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailField, resetPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    //MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailField.text else { return }
        showLoader(true, text: "Password resetting..")
        AuthService.resetPassword(withEmail: email) { _ in
            self.showLoader(false)
            self.delegate?.didSendResetPasswordLink(self)
        }
    }
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidchange(sender: UITextField) {
        viewModel.email = sender.text
    }
}
//MARK: -  FormviewModel Delegate
extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}

