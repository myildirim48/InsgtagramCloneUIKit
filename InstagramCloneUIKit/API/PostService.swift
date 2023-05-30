//
//  PostService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
import FirebaseFirestoreSwift

struct PostService {
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp",descending: true).getDocuments { snapShot, error in
            if let error {
                print("DEBUG: Error while fetching posts. \(error.localizedDescription)")
                return
            }
            guard let documents = snapShot?.documents else { return }
            let posts = documents.compactMap { try? $0.data(as: Post.self) }
            completion(posts)
        }
    }
    
    static func fetchPosts(withUid uid: String, completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snaphsot, error in
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
}
