//
//  PostViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 30.05.2023.
//

import UIKit
struct ProfileCellViewModel {
    let post: Post
    
    var imageUrl: String {
        return post.imageUrl
    }

    init(post: Post) {
        self.post = post
    }
}
