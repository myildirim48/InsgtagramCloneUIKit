//
//  CommentController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.deleagte = self
        return cv
    }()
    
    private let post: Post
    private let viewModel: CommentViewModel
    
    init(post: Post) {
        self.post = post
        self.viewModel = CommentViewModel(post: post)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.reuseIdentifier)
        navigationItem.title = "Comments"
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

//MARK: - CollectionView Datasource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentCellViewModel(comment: viewModel.comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}
//MARK: - CollectionView Delegate
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = viewModel.comments[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            
        }
    }
}
//MARK: - CollectionView FlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentCellViewModel(comment: viewModel.comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - CommentAccessoryViewDelegate
extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        inputView.clearCommentTextView()
        showLoader(true, text: "Commenting...")
        
        viewModel.uploadComment(caption: comment) { _ in
            self.showLoader(false)
            self.collectionView.reloadData()
            NotificationService.uploadNotification(toUserUid: self.post.ownerUid, type: .comment, post: self.post)
        }
    }
}
//MARK: - CommentCell Delegate
extension CommentController: CommentCellDelegate {
    func comment(wantstoShowProfileFor user: String) {
        UserService.fetchUser(withUid: user) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
