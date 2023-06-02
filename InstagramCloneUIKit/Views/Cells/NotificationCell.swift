//
//  NotificationCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import UIKit
class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .black
        return iv
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "venom"
        return label
    }()
    
    private lazy var postImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        let tap = UIGestureRecognizer(target: self, action: #selector(handleImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -  Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 24
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 100, height: 32)
        
        addSubview(postImage)
        postImage.centerY(inView: self)
        postImage.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helper
    func configure() {
        guard let viewModel else { return }
        profileImageView.downloadImage(fromUrl: viewModel.profileImageUrl)
    }
    
    //MARK: - Actions
    @objc func handleFollowTapped() {
        
    }
    @objc func handleImageTapped() {
        
    }
}
