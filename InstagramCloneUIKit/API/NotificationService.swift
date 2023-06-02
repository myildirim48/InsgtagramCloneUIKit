//
//  NotificationService.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 2.06.2023.
//

import Firebase
import FirebaseFirestoreSwift

struct NotificationService {
    static func uploadNotification(toUserUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        UserService.fetchUser(withUid: currentUid) { currentUser in
            
            var data = Notification(username: currentUser.userName,
                                    profileImageUrl: currentUser.profileImageUrl,
                                    timestamp: Timestamp(date: Date()),
                                    type: type, uid: uid)
            
            if let post {
                data.postId = post.id
                data.postImageUrl = post.imageUrl
            }
            
            guard let encodedNotifications = try? Firestore.Encoder().encode(data) else { return }
            COLLECTION_NOTIFICATIONS.document(uid).collection("users-notifications").addDocument(data: encodedNotifications) { error in
                if let error {
                    print("DEBUG: Error while creating notification.", error.localizedDescription)
                }
    
            }
        }
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_NOTIFICATIONS.document(currentUserUid).collection("users-notifications")
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapShot, error in
            guard let documents = snapShot?.documents else { return }
            let notifications = documents.compactMap({ try? $0.data(as: Notification.self) })
            completion(notifications)
        }
    }
}
