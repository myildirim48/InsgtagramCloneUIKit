//
//  CommentViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 31.05.2023.
//

import Foundation
import Firebase

class CommentViewModel {
    
    private var currentUser: User?
    private let post: Post
    var comments = [Comment]()
    
    init(post: Post) {
        self.post = post
        fetchUser()
        fetchComment()
    }
    
    func uploadComment(caption: String, completion: @escaping((Error?) -> Void)) {
        
        guard let user = currentUser else { return }
        guard let postID = post.id else { return }
        
        let data = Comment(username: user.userName, commentText: caption, postOwnerUid: post.ownerUid, profileImageUrl: user.profileImageUrl, timestamp: Timestamp(date: Date()), uid: user.uid)
            
        guard let encodedPost = try? Firestore.Encoder().encode(data) else { return }
        
        COLLECTION_POSTS.document(postID).collection("post-comments").addDocument(data: encodedPost, completion: completion)
    }
    
    func fetchComment(){
        guard let postId = post.id else { return }

        let query = COLLECTION_POSTS.document(postId).collection("post-comments")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let addedDocs = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            self.comments.append(contentsOf: addedDocs.compactMap({ try? $0.document.data(as: Comment.self) }))

        }
    }
    
    //MARK: - Fetch user
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
