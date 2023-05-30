//
//  Post.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    let caption: String
    let imageUrl: String
    var likes: Int
    let ownerImageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let ownerUserName: String
    
//    var didLike: Bool? = false
}
