//
//  FeedCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
class FeedCell: UICollectionViewCell {
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(systemName: "person.fill")
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let userNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.fill")
        return iv
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "buble.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "1 likes"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Write something about post."
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2d"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        
        addSubview(userNameButton)
        userNameButton.centerY(inView: profileImageView,
                               leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                             paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addActions()
        confgiureButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func addActions() {
        userNameButton.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        
    }
    
    func confgiureButtons() {
       let buttonsStackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 8
        
        addSubview(buttonsStackView)
        buttonsStackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    //MARK: - Actions
    @objc func didTapUsername() {
        
    }
}
