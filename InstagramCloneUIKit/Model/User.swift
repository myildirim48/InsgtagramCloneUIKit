//
//  User.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    let fullName: String
    let profileImageUrl: String
    let uid: String
    let userName: String
    
    var isFollowed: Bool = false
    var stats: UserStats?

    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
}
struct UserStats: Codable {
    var following: Int
    var followers: Int
    var posts: Int
}
