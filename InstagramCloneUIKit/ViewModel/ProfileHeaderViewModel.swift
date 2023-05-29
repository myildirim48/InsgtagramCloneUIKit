//
//  ProfileHeaderViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import Foundation
struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullName
    }
    
    var profileImageurl: String {
        return user.profileImageUrl
    }
    
    
    init(user: User) {
        self.user = user
    }
}
