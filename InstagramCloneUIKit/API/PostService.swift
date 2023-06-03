//
//  PostService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

struct PostService {
//    static func fetchPosts(completion: @escaping([Post]) -> Void) {
//        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapShot, error in
//            if let error {
//                print("DEBUG: Error while fetching posts. \(error.localizedDescription)")
//                return
//            }
//            guard let documents = snapShot?.documents else { return }
//            let posts = documents.compactMap { try? $0.data(as: Post.self) }
//            completion(posts)
//        }
//    }
//
    static func fetchPost(withPostId id: String, completion: @escaping(Post) -> Void ) {
        COLLECTION_POSTS.document(id).getDocument { snapshot, error in
            if let error {
                print("DEBUG: Error while fetching post. \(error.localizedDescription)")
                return
            }
            guard let snapshot else { return }
            guard let post = try? snapshot.data(as: Post.self) else { return }

            completion(post)
        }
    }
    static func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()

        COLLECTION_USERS.document(currentUserUid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    posts = posts.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
                    completion(posts)
                }
            })
        }
    }
    
    static func fetchPosts(withUid uid: String, completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
            .getDocuments { snaphsot, error in
                if let error {
                    print("DEBUG: Error while fetching posts. \(error.localizedDescription)")
                    return
                }
                
                guard let document = snaphsot?.documents else { return }
                var posts = document.compactMap { try? $0.data(as: Post.self) }
                posts = posts.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }

                completion(posts)

            }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let postID = post.id else { return }
        
        COLLECTION_POSTS.document(postID).collection("post-likes").document(currentUserUid)
            .setData([:]) { _ in
                COLLECTION_USERS.document(currentUserUid).collection("user-likes").document(postID)
                    .setData([:]) { _ in
                        COLLECTION_POSTS.document(postID).updateData(["likes": post.likes + 1],completion: completion)
                    }
            }
    }
    
   static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
       guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
       guard let postID = post.id else { return }
       guard post.likes > 0 else { return }
       
        COLLECTION_POSTS.document(postID).collection("post-likes").document(currentUserUid).delete { _ in
            COLLECTION_USERS.document(currentUserUid).collection("user-likes").document(postID)
                .delete { _ in
                    COLLECTION_POSTS.document(postID).updateData(["likes": post.likes - 1],completion: completion)
                }
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let postID = post.id else { return }
        COLLECTION_USERS.document(currentUserUid).collection("user-likes").document(postID)
            .getDocument { snapshot, _ in
                guard let didLike = snapshot?.exists else { return }
                    completion(didLike)
            }
    }
    
    static func updateUserFeedAfterFollowing(userUid: String, didFollow: Bool) {
        UserService.fetchUser(withUid: userUid) { user in
            
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let docsID = documents.map { $0.documentID }
            
            docsID.forEach { id in
                if didFollow {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    }

}
