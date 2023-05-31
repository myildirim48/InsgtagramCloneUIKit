//
//  CommentCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit

protocol CommentCellDelegate: AnyObject {
    func comment(wantstoShowProfileFor user: String)
}

class CommentCell: UICollectionViewCell {
    //MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
     
    weak var delegate: CommentCellDelegate?
    
    var viewModel: CommentCellViewModel? {
        didSet {
            configure()
        }
    }
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let commentOwner: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    
    private let commentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        
        addSubview(commentOwner)
        commentOwner.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: commentOwner, leftAnchor: commentOwner.rightAnchor, paddingLeft: 8)
        commentLabel.numberOfLines = 0
        
        
        addSubview(commentTimeLabel)
        commentTimeLabel.centerY(inView: commentLabel)
        commentTimeLabel.anchor(right: rightAnchor, paddingRight: 8)
        
        commentOwner.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure() {
        guard let viewModel else { return }
        profileImageView.downloadImage(fromUrl: viewModel.profileImageUrl)
        commentOwner.setTitle(viewModel.userName, for: .normal)
        commentLabel.text = viewModel.commentText
        commentTimeLabel.text = viewModel.timeStamp
    }
    
    //MARK: - Actions
    
    @objc func handleSelect() {
        guard let viewModel else { return }
        delegate?.comment(wantstoShowProfileFor: viewModel.userUid)
    }
}
