//
//  NotificationController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
class NotificationController: UITableViewController {
    //MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    private let refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
  
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    //MARK: -  Actions
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            self.checkIfUserFollowed()
        }
    }
    
    func checkIfUserFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            UserService.checkIfUserFollower(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    func fetchAndShowProfile(uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func fetchAndShowPost(uid: String) {
        PostService.fetchPost(withPostId: uid) { post in
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
//MARK: - TableviewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}
//MARK: - TableView Datasource
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifications[indexPath.row].postImageUrl != nil {
            guard let uid = notifications[indexPath.row].postId else { return }
            fetchAndShowPost(uid: uid)
        }else {
            let uid = notifications[indexPath.row].uid
            fetchAndShowProfile(uid: uid)
        }

    }
}
//MARK: - Notificationcell Delegate
extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wansToShowProfile uid: String) {
    fetchAndShowProfile(uid: uid)
    }
    func cell(_ cell: NotificationCell, wantsToFollowUser uid: String) {
        showLoader(true, text: "Following")
            UserService.follow(uid: uid) { _ in
            NotificationService.uploadNotification(toUserUid: uid, type: .follow)
                cell.viewModel?.notification.userIsFollowed.toggle()
                PostService.updateUserFeedAfterFollowing(userUid: uid, didFollow: true)
                self.showLoader(false)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnFollowUser uid: String) {
        showLoader(true, text: "Unfollowing")
        UserService.unfollow(uid: uid) { _ in
            cell.viewModel?.notification.userIsFollowed.toggle()
            PostService.updateUserFeedAfterFollowing(userUid: uid, didFollow: false)
            self.showLoader(false)
        }
    }
    func cell(_ cell: NotificationCell, wantsToShowPost postId: String) {
       fetchAndShowPost(uid: postId)
    }
}
