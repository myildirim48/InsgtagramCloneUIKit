//
//  AuthButton.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit
class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.5700682402, green: 0.3959509134, blue: 0.9983097911, alpha: 1).withAlphaComponent(0.5)
        setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        layer.cornerRadius = 5
        isEnabled = false
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
