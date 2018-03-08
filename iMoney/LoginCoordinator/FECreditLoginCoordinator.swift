//
//  FECreditLoginCoordinator.swift
//  iMoney
//
//  Created by hoaqt on 3/8/18.
//  Copyright © 2018 com.noron. All rights reserved.
//

import UIKit
import ILLoginKit
import Firebase
import FirebaseDatabase
import PKHUD

protocol FECreditLoginCoordinatorDelegate {
    func initUser(user: User)
}

class FECreditLoginCoordinator: LoginCoordinator {
    public var delegate: FECreditLoginCoordinatorDelegate?
    
    
    func configureAppearance() {
        backgroundImage = UIImage(named: "iMoney-background")!
            
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        loginButtonText = "Đăng nhập"
        signupButtonText = "Tạo tài khoản"
        shouldShowLoginWithFacebook = false
        shouldShowForgotPassword = false
        forgotPasswordButtonText = "Quên mật khẩu?"
        recoverPasswordButtonText = "Phục hồi"
        namePlaceholder = "Tên"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Mật khẩu!"
        repeatPasswordPlaceholder = "Nhập lại mật khẩu!"
        phonePlaceholder = "Số điện thoại di động"
    }
    
    override func signup(name: String, email: String, password: String, phoneNumber: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        HUD.show(.progress)
        Auth.auth().createUserAndRetrieveData(withEmail: email, password: password, completion: { (result, error) in
            guard (error == nil) else {
                self.showMessage(title: "Lỗi", message: "Xin hãy thử lại")
                return
            }
            let user = result!.user
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (error) in
                guard (error == nil) else {
                    HUD.flash(.error, delay: 1.0)
                    return
                }
                ref.child("users/\(user.uid)/userphonenumber").setValue(phoneNumber)
                HUD.flash(.success, delay: 1.0)
                self.popBackScreen()
            })
        })
            
    }
    
    override func login(email: String, password: String) {
        HUD.show(.progress)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard (error == nil) else {
                HUD.flash(.error, delay: 1.0)
                return
            }
            self.delegate?.initUser(user: user!)
            HUD.flash(.success, delay: 1.0)
            self.finish()
        }
    }
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    
    

}
