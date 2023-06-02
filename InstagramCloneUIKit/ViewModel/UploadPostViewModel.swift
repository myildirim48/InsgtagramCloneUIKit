//
//  UploadPostViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import Foundation
import Firebase

class UploadPostViewModel {
    
    private var currentUser: User?
    
    init() {
        fetchUser()
    }
    
    func uploadPost(caption: String, image: UIImage, completion: @escaping((Error?) -> Void)) {
        
        guard let user = currentUser else { return }
        
        ImageUploader.uploadImage(image: image, type: .post) { imageUrl in
            
            let data = Post(caption: caption, imageUrl: imageUrl, likes: 0, ownerImageUrl: user.profileImageUrl, ownerUid: user.uid, timestamp: Timestamp(date: Date()), ownerUserName: user.userName)
            
            guard let encodedPost = try? Firestore.Encoder().encode(data) else { return }
            
            let docref = COLLECTION_POSTS.addDocument(data: encodedPost, completion: completion)
            self.updateUserFeedAfterPost(postId: docref.documentID)
        }
    }
    
    
    private func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            guard let documenst = snapshot?.documents else { return }
            documenst.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            COLLECTION_FOLLOWERS.document(uid).collection("user-feed").document(postId).setData([:])
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
