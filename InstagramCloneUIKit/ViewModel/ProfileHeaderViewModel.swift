//
//  ProfileHeaderViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import UIKit
struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullName
    }
    
    var profileImageurl: String {
        return user.profileImageUrl
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed  ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollowed ? .black : .white
    }
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats?.followers ?? 0, label: "Followers")
    }
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats?.following ?? 0, label: "Following")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: 0, label: "Posts")
    }
    
   private func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value) \n ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        return attributedText
    }
    
    
    init(user: User) {
        self.user = user
    }
}
