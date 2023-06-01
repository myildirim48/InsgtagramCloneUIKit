//
//  FeedCellViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 31.05.2023.
//

import Foundation
import Firebase

class FeedCellViewModel {
    //MARK: - Properties
    var post: Post
    private var currentUser: User?
    
    var imageUrl: String {
        return post.imageUrl
    }
    
    var caption: String {
        return post.caption
    }
    
    var ownerImageUrl: String {
        return post.ownerImageUrl
    }
    
    var ownerUsername: String {
        return post.ownerUserName
    }
    
    var didLike: Bool = false
    
    var likeButtonImageString: String {
        return didLike ? "heart.fill" : "heart"
    }
    
    var likeButtonColor: UIColor {
        return didLike ? .red : .black
    }

    func likeButtonText() -> String {
        if post.likes == 1 || post.likes == 0 {
            return "\(post.likes) like"
        }else {
            return "\(post.likes) likes"
        }
    }

    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? "n / a"
    }
    
    
    //MARK: - Lifecycle
    init(post: Post) {
        self.post = post
        self.didLike = post.didLike ?? false
    }
}
