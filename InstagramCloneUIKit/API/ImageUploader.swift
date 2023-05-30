//
//  ImageUploader.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import FirebaseStorage
import UIKit

enum UploadType {
case profile, post
    
    var filePath: StorageReference {
        let fileName = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        case .post:
            return Storage.storage().reference(withPath: "/post_images/\(fileName)")
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, type: UploadType , completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let reference = type.filePath
        
        reference.putData(imageData) { storage, error in
            if let error {
                print("DEBUG: Error while uploading images, \(error.localizedDescription)")
                return
            }
            
            reference.downloadURL { url, _ in
                guard let imgUrl = url?.absoluteString else { return }
                completion(imgUrl)
            }
        }
    }
}
