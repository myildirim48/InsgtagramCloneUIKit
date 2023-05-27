//
//  TextButton.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit
class TextButton: UIButton {
    
    init(firstPart: String, lastPart: String) {
        super.init(frame: .zero)
        let atts : [NSAttributedString.Key: Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart)  ", attributes: atts)
        let boldAtts : [NSAttributedString.Key: Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: lastPart, attributes: boldAtts))
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
