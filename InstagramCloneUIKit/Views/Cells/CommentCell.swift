//
//  CommentCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit


class CommentCell: UICollectionViewCell {
    //MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        let attributerString = NSMutableAttributedString(string: "joker", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributerString.append(NSAttributedString(string: " Some test comment here..", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributerString
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
