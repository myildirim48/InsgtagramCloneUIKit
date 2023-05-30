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
        guard let userID = currentUser?.id else { return }
        
        ImageUploader.uploadImage(image: image, type: .post) { imageUrl in
            
            let data = Post(caption: caption, imageUrl: imageUrl, likes: 0, ownerImageUrl: user.profileImageUrl, ownerUid: user.uid, timestamp: Timestamp(date: Date()), ownerUserName: user.userName)
            
            guard let encodedPost = try? Firestore.Encoder().encode(data) else { return }
            
            COLLECTION_POSTS.document(userID).setData(encodedPost, completion: completion)
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
