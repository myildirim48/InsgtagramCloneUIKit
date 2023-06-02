//
//  NotificationCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import UIKit
protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wantsToFollowUser uid: String)
    func cell(_ cell: NotificationCell, wantsToUnFollowUser uid: String)
    func cell(_ cell: NotificationCell, wantsToShowPost postId: String)
    func cell(_ cell: NotificationCell, wansToShowProfile uid: String)
}
class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.image = UIImage(systemName: "person.fill")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        iv.tintColor = .black
        return iv
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
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
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -  Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 24
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        

        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
       
        contentView.addSubview(postImage)
        postImage.centerY(inView: self)
        postImage.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helper
    func configure() {
        guard let viewModel else { return }
        profileImageView.downloadImage(fromUrl: viewModel.profileImageUrl)
        postImage.downloadImage(fromUrl: viewModel.postImageUrl ?? "")
        infoLabel.attributedText = viewModel.message
        postImage.isHidden = viewModel.shouldHidePostImage
        
        followButton.isHidden = !viewModel.shouldHidePostImage
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.tintColor = viewModel.followButtonTextColor
        followButton.backgroundColor = viewModel.followButtonColor

    }

    //MARK: - Actions
    @objc func handleFollowTapped() {
        guard let viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnFollowUser: viewModel.notificationOwnerUid)
        } else {
            delegate?.cell(self, wantsToFollowUser: viewModel.notificationOwnerUid)
        }
    }
    @objc func handleImageTapped() {
        guard let viewModel else { return }
        delegate?.cell(self, wantsToShowPost: viewModel.notificationPostId)
    }
    
    @objc func handleProfileImageTapped() {
        guard let viewModel else { return }
        delegate?.cell(self, wansToShowProfile: viewModel.notificationOwnerUid)
    }
}
