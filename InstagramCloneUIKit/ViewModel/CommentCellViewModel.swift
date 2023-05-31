//
//  CommentCellViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 31.05.2023.
//

import UIKit

struct CommentCellViewModel {
    private let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var userUid: String {
        return comment.uid
    }
    
    var profileImageUrl: String {
        return comment.profileImageUrl
    }
    
    var userName: String {
        return comment.username
    }
    
    var commentText: String {
        return comment.commentText
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: comment.timestamp.dateValue(), to: Date()) ?? "n / a"
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
