//
//  FeedController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
import Firebase
class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configureUI()

        if post != nil {
            checkIfUserLiked()
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            navigationItem.title = "Feed"
        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    //MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }
        PostService.fetchFeedPosts(completion: { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLiked()
        })
    }

    func checkIfUserLiked() {
        
        if let post {
            PostService.checkIfUserLikedPost(post: post) { didlike in
                self.post?.didLike = didlike
            }
        } else {
            posts.forEach { post in
               PostService.checkIfUserLikedPost(post: post) { didLike in
                   if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                       self.posts[index].didLike = didLike
                   }
               }
           }
        }
    }
    
    //MARK: - Actions
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("DEBUG: Error while logout")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
}

//MARK: -  CollectionView Datasource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post != nil ? 1 : posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post {
            cell.viewModel = FeedCellViewModel(post: post)
        }else {
            cell.viewModel = FeedCellViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}

//MARK: -  CollectionView FlowLayout Delegate
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let hegiht = width * 1.7
        return CGSize(width: view.frame.width, height: hegiht)
    }
}
//MARK: - FeedCell Delegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfile userUid: String) {
        UserService.fetchUser(withUid: userUid) { user in
            
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func cell(_ cell: FeedCell, wantsToShowComments post: Post) {
        
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.didLike.toggle()
        guard let didlike = post.didLike else { return }
        showLoader(true)
        if didlike {
            PostService.unlikePost(post: post) { _ in
                self.showLoader(false)
            }
        }else {
            PostService.likePost(post: post) { _ in
                self.showLoader(false)
                NotificationService.uploadNotification(toUserUid: post.ownerUid, type: .like, post: post)
            }
        }
    }
}
