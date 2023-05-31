//
//  Comment.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 31.05.2023.
//

import Firebase

import FirebaseFirestoreSwift
struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let username: String
    let commentText: String
    let postOwnerUid: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let uid: String
}
