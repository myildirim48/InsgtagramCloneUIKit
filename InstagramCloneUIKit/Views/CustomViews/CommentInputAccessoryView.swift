//
//  CommentInputAccessoryView.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 31.05.2023.
//

import UIKit
protocol CommentInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}
class CommentInputAccessoryView: UIView {
    //MARK: - Properties
    
    weak var deleagte: CommentInputAccessoryViewDelegate?
    
    private let inputTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShowCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Post", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        postButton.addTarget(self, action:#selector(handlePost), for: .touchUpInside)
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Helpers
    
    func clearCommentTextView() {
        inputTextView.text = nil
        inputTextView.placeholderLabel.isHidden = false
    }
    
    //MARK: - Actions
    @objc func handlePost() {
        deleagte?.inputView(self, wantsToUploadComment: inputTextView.text)
    }
}
