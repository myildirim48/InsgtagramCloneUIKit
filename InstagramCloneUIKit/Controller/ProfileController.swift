//
//  ProfileController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//
import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: -  Properties
    
    private var user: User
    private var posts = [Post]()
    
    //MARK: - Lifcecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIfUserFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = user.userName
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(ProfileHedaerView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHedaerView.reuseIdentifier)
    }
    //MARK: - API
    func checkIfUserFollowed() {
        UserService.checkIfUserFollower(uid: user.uid) { isFollowing in
            self.user.isFollowed = isFollowing
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(withUid: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
}
//MARK: - UICollectionView Datasource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
            cell.viewModel = ProfileCellViewModel(post: posts[indexPath.row])
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHedaerView.reuseIdentifier, for: indexPath) as! ProfileHedaerView
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        return header
    }
}

//MARK: - UICollectionView Delegate
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: - UICollectionViewFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: - ProfileHeader Delegate
extension ProfileController: ProfileHeaderDelegate{
    func header(_ profileHeader: ProfileHedaerView, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            print("DEBUG: Show edit profile view")
        }else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { _ in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                PostService.updateUserFeedAfterFollowing(userUid: user.uid, didFollow: false)
            }
        }else {
            UserService.follow(uid: user.uid) { _ in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.uploadNotification(toUserUid: user.uid, type: .follow)
                PostService.updateUserFeedAfterFollowing(userUid: user.uid, didFollow: true)
            }
        }
    }
}
