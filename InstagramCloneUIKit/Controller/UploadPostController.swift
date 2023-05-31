//
//  UploadPostController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
import JGProgressHUD

protocol PostUploadDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    //MARK: -  Properties
    
    weak var delegate: PostUploadDelegate?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let viewModel = UploadPostViewModel()
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption..."
        tv.placeholderShowCenter = false
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func checkMaxLengt(_ textView: UITextView) {
        let maxLength = 100
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
    
    func configureUI()  {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        
        captionTextView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 16)
        photoImageView.centerX(inView: view)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,
                                   paddingBottom: -8, paddingRight: 12)
    }
    
    //MARK: - Actions
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    @objc func handleDone() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading post..."
        hud.show(in: view)
        
        guard let selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        viewModel.uploadPost(caption: caption, image: selectedImage) { _ in
            hud.dismiss()
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
}

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLengt(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
