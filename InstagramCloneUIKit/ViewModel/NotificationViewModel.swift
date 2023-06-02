//
//  NotificationViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: String? {
        return notification.postImageUrl
    }
    
    var profileImageUrl: String {
        return notification.profileImageUrl
    }
    
    
}
