//
//  UserService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import Firebase
typealias FirestoreCompletion = (Error?) -> Void
struct UserService {
    
    //MARK: - Follow logic
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user-following").document(uid)
            .setData([:]) { error in
                if let error {
                    print("DEBUG : ERROR while following user. \(error.localizedDescription)")
                    return
                }
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUserUid)
                    .setData([:],completion: completion)
            }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user-following").document(uid)
            .delete { error in
                if let error {
                    print("DEBUG : ERROR while unfollowing user. \(error.localizedDescription)")
                    return
                }
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUserUid)
                    .delete(completion: completion)
            }
    }
    
    static func checkIfUserFollower(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user-following").document(uid)
            .getDocument { snapshot, error in
                if let error {
                    print("DEBUG : ERROR while checking following users. \(error.localizedDescription)")
                    return
                }
                guard let isfollowing = snapshot?.exists else { return }
                completion(isfollowing)
            }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snahpsot, _ in
            let followers = snahpsot?.documents.count ?? 0
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                completion(UserStats(following: following, followers: followers))
            }
        }
    }
    //MARK: - User logic
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
