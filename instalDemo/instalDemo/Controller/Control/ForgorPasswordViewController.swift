//
//  ForgorPasswordViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/25/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ForgorPasswordViewController: UIViewController {

    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendLinkButtonPressed(_ sender: UIButton) {
        let contactEmail = txtContact.text!
        
        if contactEmail.isEmail == false {
            lblStatus.isHidden = false
            lblStatus.text = "Please Enter an valid Email"
        }
        
        SVProgressHUD.show()
        
        Auth.auth().sendPasswordReset(withEmail: contactEmail) { (Error) in
            SVProgressHUD.dismiss()
            if Error == nil {
                self.lblStatus.isHidden = false
                self.lblStatus.text = "An email message was sent to your \(contactEmail)"
            }
            else{
                self.lblStatus.isHidden = false
                self.lblStatus.text = Error?.localizedDescription
                return
            }
        }
        
        
    }
    
    @IBAction func goToSignIn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
