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

protocol FECreditLoginCoordinatorDelegate {
    func initUser(user: User)
}

class FECreditLoginCoordinator: LoginCoordinator {
    public var delegate: FECreditLoginCoordinatorDelegate?
    
    
    // Customize LoginKit. All properties have defaults, only set the ones you want.
    func configureAppearance() {
        // Customize the look with background & logo images
        backgroundImage = UIImage(named: "iMoney-background")!
            
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
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
                    self.showMessage(title: "Lỗi", message: "Xin hãy thử lại")
                    return
                }
                ref.child("users/\(user.uid)/userphonenumber").setValue(phoneNumber)
                self.popBackScreen()
            })
        })
            
    }
    
    override func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard (error == nil) else {
                self.showMessage(title: "Lỗi", message: "Thông tin đăng nhập không chính xác")
                return
            }
            self.delegate?.initUser(user: user!)
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
