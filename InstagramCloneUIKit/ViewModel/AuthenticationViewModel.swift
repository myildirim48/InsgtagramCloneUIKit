//
//  AuthenticationViewModel.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 27.05.2023.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.4150995016, green: 0.1858755052, blue: 0.9084364772, alpha: 1) :  #colorLiteral(red: 0.5700682402, green: 0.3959509134, blue: 0.9983097911, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}

struct RegistrationViewModel: AuthenticationViewModel {

    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor  {
        return formIsValid ? #colorLiteral(red: 0.4150995016, green: 0.1858755052, blue: 0.9084364772, alpha: 1) :  #colorLiteral(red: 0.5700682402, green: 0.3959509134, blue: 0.9983097911, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
    
}
