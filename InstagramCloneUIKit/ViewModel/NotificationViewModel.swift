//
//  NotificationViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: String? {
        return notification.postImageUrl
    }
    
    var profileImageUrl: String {
        return notification.profileImageUrl
    }
    
    var notificationOwnerUid: String {
        return notification.uid
    }
    
    var notificationPostId: String {
        return notification.postId ?? ""
    }
    
    private var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? "n / a"
    }
    
    
    var message: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timeStamp)", attributes: [.font : UIFont.systemFont(ofSize: 12),
                                                                                       .foregroundColor : UIColor.lightGray]))
        return attributedText
    }
    
    var shouldHidePostImage: Bool { return self.notification.type == .follow }
    
    var followButtonText: String {  return notification.userIsFollowed ? "Following" : "Follow"}
    
    var followButtonColor: UIColor {  return notification.userIsFollowed ? .white : .systemBlue }
    var followButtonTextColor: UIColor {  return notification.userIsFollowed ? .black : .white }

}
