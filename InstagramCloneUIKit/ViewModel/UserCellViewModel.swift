//
//  UserCellViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 29.05.2023.
//

import Foundation
struct UserCellViewModel {
    
    private let user: User
    
    var profileImageUrl: String {
        return user.profileImageUrl
    }
    
    var userName: String {
        return user.userName
    }
    
    var fullName: String {
        return user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
}
