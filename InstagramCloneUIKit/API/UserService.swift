//
//  UserService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS
            .document(uid).getDocument { snapShot, error in
                if let error {
                    print("DEBUG : ERROR while fetching user. \(error.localizedDescription)")
                    return
                }
                guard let snapShot else { return }
                guard let user = try? snapShot.data(as: User.self) else { return }
                
                completion(user)
            }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            if let error {
                print("DEBUG: Error while fetching users. \(error.localizedDescription)")
            }
            guard let snapshot else { return }
            let users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            completion(users)
        }
    }
}
