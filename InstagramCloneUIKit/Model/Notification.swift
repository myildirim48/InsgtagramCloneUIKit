//
//  Notification.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import Firebase
import FirebaseFirestoreSwift

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
    
    let username: String
    let profileImageUrl: String
    
    var postId: String?
    var postImageUrl: String?
    
    let timestamp: Timestamp
    let type: NotificationType
    let uid: String
    
    var userIsFollowed: Bool = false
}

enum NotificationType: Int, Codable {
case like, comment, follow
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " liked one of your post."
        case .comment:
            return " commented one of your post."
        case .follow:
            return " started follwoing you."
        }
    }
}
