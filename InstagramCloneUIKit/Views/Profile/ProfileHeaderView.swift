//
//  ProfileHeaderView.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import UIKit

class ProfileHedaerView: UICollectionReusableView {
    
    //MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 13, label: "Posts")
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 31, label: "Followers")
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 25 , label: "Following")
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.3x3.fill"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                         paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.centerY(inView: profileImageView)
        stackView.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                         paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(topDivider)
        addSubview(buttonStack)
        addSubview(bottomDivider)
        
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        bottomDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value) \n ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        return attributedText
    }
    
    func configure() {
        guard let viewModel else { return }
        nameLabel.text = viewModel.fullName
        profileImageView.downloadImage(fromUrl: viewModel.profileImageurl)
    }
    
    
    //MARK: - Actions
    
    @objc func editProfileButtonTapped() {
        
    }
}
