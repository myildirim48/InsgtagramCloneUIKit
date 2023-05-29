//
//  RegistrationController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit
import JGProgressHUD
class RegistrationController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private var profileImage: UIImage?
    
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
        addImageButton.addTarget(self, action: #selector(handleSelecPhoto), for: .touchUpInside)

    }
    
    //MARK: - Actions
    
    @objc func handleSelecPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true )
    }
    
    @objc func handleRegister() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Creating user.."
        hud.show(in: view)
        guard let email = emailTextField.text else { return }
        guard let password = passwordField.text else { return }
        guard let fullname = fullnameField.text else { return }
        guard let username = usernameField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullName: fullname, userName: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error {
                print("DEBUG: Error while creating user, \(error.localizedDescription)")
                return
            }
            hud.dismiss(animated: true)
            self.delegate?.authenticationCompleted()
        }
        
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
//MARK: -  FormViewModel
extension RegistrationController: FormViewModel {
    func updateForm() {
        
        registerButton.backgroundColor = viewModel.buttonBackgroundColor
        registerButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        registerButton.isEnabled = viewModel.formIsValid
    }
}

//MARK: -  ImagePicker
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        addImageButton.layer.cornerRadius = addImageButton.frame.width / 2
        addImageButton.layer.masksToBounds = true
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.borderWidth = 2
        addImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        profileImage = selectedImage
        
        self.dismiss(animated: true)
    }
}
