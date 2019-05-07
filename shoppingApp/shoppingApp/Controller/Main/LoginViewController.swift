//
//  LoginViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/20/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeyChainService().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func AddKeyChainAfterLogin(uid: String){
        let keyChain = KeyChainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }

    @IBAction func LogInBtnPressed(_ sender: UIButton) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        if email.isEmail == false{
            lblStatus.isHidden = false
            lblStatus.text = "Please Enter Valid Email"
            return
        }
        if password.count < 6{
            lblStatus.isHidden = false
            lblStatus.text = "Please Enter Valid Password"
            return
        }
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            SVProgressHUD.dismiss()
            if error == nil {
                strongSelf.AddKeyChainAfterLogin(uid: user!.user.uid)
                strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
            }
            else{
                strongSelf.lblStatus.isHidden = false
                strongSelf.lblStatus.text = error?.localizedDescription
            }
            self!.initSet()
        }
        
    }
    
    @IBAction func ForgotPasswordBtn(_ sender: UIButton) {
        self.initSet()
        performSegue(withIdentifier: "forgotPasswordSegue", sender: self)
    }
    @IBAction func SignUpBtn(_ sender: UIButton) {
        self.initSet()
        lblStatus.isHidden = true
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    func initSet(){
        txtEmail.text = ""
        txtPassword.text = ""
    }
}

