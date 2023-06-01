//
//  FeedCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
protocol FeedCellDelegate: AnyObject {
    func cell(_ cell: FeedCell, wantsToShowComments post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
}
class FeedCell: UICollectionViewCell {
    //MARK: - Properties
    
    var viewModel: FeedCellViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: FeedCellDelegate?
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
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
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.25).isActive = true
        
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
    func configure() {
        guard let viewModel else { return }
        captionLabel.text = viewModel.caption
        postImageView.downloadImage(fromUrl: viewModel.imageUrl)
        profileImageView.downloadImage(fromUrl: viewModel.ownerImageUrl)
        userNameButton.setTitle(viewModel.ownerUsername, for: .normal)
        likesLabel.text = viewModel.likeButtonText()
        postTimeLabel.text = viewModel.timeStamp
        
        likeButton.tintColor = viewModel.likeButtonColor
        likeButton.setImage(UIImage(systemName: viewModel.likeButtonImageString), for: .normal)
    }
    func addActions() {
        userNameButton.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
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
    @objc func handleComment() {
        guard let viewModel else { return }
        delegate?.cell(self, wantsToShowComments: viewModel.post)
    }
    @objc func handleLike() {
        guard let viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
        
        if viewModel.didLike {
            viewModel.post.likes += 1
        } else {
            viewModel.post.likes -= 1
        }
        
        likeButton.setImage(UIImage(systemName: viewModel.likeButtonImageString), for: .normal)
        likeButton.tintColor = viewModel.likeButtonColor
        likesLabel.text = viewModel.likeButtonText()

        viewModel.post.didLike?.toggle()
    }
}
