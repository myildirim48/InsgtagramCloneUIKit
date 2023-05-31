//
//  PostViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
struct PostViewModel {
    let post: Post
    
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
    
    var likes: String {
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
    
    init(post: Post) {
        self.post = post
    }
}
