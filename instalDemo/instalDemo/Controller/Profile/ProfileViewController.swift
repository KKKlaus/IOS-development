//
//  ProfileViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/26/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        LoadUserProfile()
        txtEmail.isUserInteractionEnabled = false
        //process tap image, not use a button to implement imagePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.changePicture))
        profilePic.addGestureRecognizer(tapGesture)
        profilePic.isUserInteractionEnabled = true
    }
    
    func LoadUserProfile(){
        
        guard let user = Auth.auth().currentUser else { return }
        
        let userId = user.uid
        
        let databaseRef = Database.database().reference().child("Users").child(userId)
        
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            let user = UserModel(userId: userId, dictionary: dict as! Dictionary<String, AnyObject>)
            self.txtEmail.text = user.email
            self.txtFullName.text = user.name
            let url = user.imageURL!
            
            if url == "" {
                print("please upload an image")
                return
            }
            
//            let storageRef = Storage.storage().reference(forURL: url)
//            storageRef.getData(maxSize: 1024*1024*1024, completion: { (data, error) in
//                if error != nil{
//                    print(error.debugDescription)
//                    return
//                }else{
//                    let image = UIImage(data: data!)
//                    self.profilePic.image = image
//                }
//            })
            let url2 = URL(string: url)
            self.profilePic.kf.setImage(with: url2)
        }
                

    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do{
            try
                firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return
        }
        KeyChainService().keyChain.delete("uid")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fullNameEditingDone(_ sender: Any) {
        guard  let user = Auth.auth().currentUser else { return }
        
        let id = user.uid
        let ref = Database.database().reference().child("Users").child(id).child("name")
        ref.setValue(txtFullName.text)
        
    }
    
    @objc func changePicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction( UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction( UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func upLaodProfilePic() {
        guard let user = Auth.auth().currentUser else { return }
        guard let image = profilePic.image else {
            lblStatus.isHidden = false
            self.lblStatus.text = "Please upload an image"
            return
        }
        
        let userID = user.uid
        guard let data = image.jpegData(compressionQuality: 0.5) else {return}
        
        let storageRef = Storage.storage().reference().child("profile_image").child(userID).child("image.png")
        
        SVProgressHUD.show()
        storageRef.putData(data, metadata: nil){ (metaFromStorage, error) in
        
            SVProgressHUD.dismiss()
        
            if error != nil {
                print("Error accured in uploading file")
                print(error.debugDescription)
                return;
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else{
                    print(error.debugDescription)
                    return
                }
                let changeRequest = user.createProfileChangeRequest()
                
                let picURL = URL(string: downloadURL.absoluteString)
                
                changeRequest.photoURL = picURL
                changeRequest.commitChanges { error in
                    if error != nil {
                        print(error.debugDescription)
                        return
                    }
                    print("profile updated")
                }
                
                let id = user.uid
                let databaseRef = Database.database().reference().child("Users").child(id).child("imageURL")
                databaseRef.setValue(downloadURL.absoluteString)
            })
    
        }
    }
    
    //P.S. click image to change the picture, click comfirmchange button to upload image to Firebase
    @IBAction func comfirmChange(_ sender: UIButton) {
        upLaodProfilePic()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profilePic.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
