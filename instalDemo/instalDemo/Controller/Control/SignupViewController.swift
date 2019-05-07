//
//  SignupViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/25/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtComfirmPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        txtPassword.textContentType = .newPassword
        txtComfirmPassword.textContentType = .newPassword
    }
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        let comfirmPassword = txtComfirmPassword.text!
        var userID = ""
        if email.isEmail == false {
            lblStatus.isHidden = false
            lblStatus.text = "Please Enter valid Email"
            return
        }
        
        if(password != comfirmPassword || password.count < 6){
            lblStatus.isHidden = false
            lblStatus.text = "Please Enter valid Password"
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            SVProgressHUD.dismiss()
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.lblStatus.isHidden = false
                self.lblStatus.text = error?.localizedDescription
                return
            }
            userID = authResult?.user.uid ?? "nil"
            print("userID:")
            print(userID)
    
            let values = ["email" : email,
                          "imageURL" : "",
                          "name" : "",
                          "signupDate" : NSDate().timeIntervalSince1970,
                          "title" : ""
                          ] as [String : Any]
    
            let databaseUserID = Database.database().reference().child("Users").child(userID)
    
            SVProgressHUD.show()
            databaseUserID.updateChildValues(values) { (err, ref) in
    
                SVProgressHUD.dismiss()
                if err != nil {
                    print(err.debugDescription)
                    return
                }
            }
            self.signUpSuccess()
        }
    }
    
    func signUpSuccess(){
        txtEmail.text = ""
        txtPassword.text = ""
        txtComfirmPassword.text = ""
        lblStatus.isHidden = false
        lblStatus.text = "Signed Up Successfully"
        return
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
