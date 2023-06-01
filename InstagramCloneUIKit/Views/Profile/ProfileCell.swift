//
//  ProfileCell.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import UIKit
class ProfileCell: UICollectionViewCell {
    
    //MARK: -  Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var viewModel: ProfileCellViewModel? {
        didSet { configure() }
    }
    
    private let postImageView: UIImageView = {
    let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: -  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure() {
        guard let viewModel else { return }
        postImageView.downloadImage(fromUrl: viewModel.imageUrl)
    }
}
