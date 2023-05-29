//
//  AuthService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}
struct AuthService {
    static func registerUser(withCredential credential: AuthCredentials, completion: @escaping (Error?)-> Void) {
        ImageUploader.uploadImage(image: credential.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { authResult, error in
                if let error {
                    print("DEBUG : Errorr while creating user, \(error.localizedDescription)")
                    return
                }
                
                guard let uid = authResult?.user.uid else { return }
                
                let userData = User(email: credential.email, fullName: credential.fullName, profileImageUrl: imageUrl, uid: uid, userName: credential.userName)
                
                guard let encodedUser = try? Firestore.Encoder().encode(userData) else { return }
                
                COLLECTION_USERS
                    .document(uid).setData(encodedUser)
            }
            
        }
    }
    
    static func logUserIn(email: String, password: String, completion: @escaping((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
