//
//  PostViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/26/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

/*
     * P.S. Here I cenceled the button to post image, but used TapGestureRecognizer to post image by just clicking the image :)
 */
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        txtPost.text = "Share something interesting..."
        txtPost.textColor = UIColor.lightGray
        txtPost.returnKeyType = .done
        txtPost.delegate = self
        //process tap image, not use a button to implement imagePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostViewController.changePicture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        //add line to divide every navigation bar
        addLine()
    }
    
    func addLine(){
        let lineView = UIView(frame: CGRect(x: 0, y: 212, width: self.view.frame.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 256, width: self.view.frame.width, height: 1.0))
        lineView2.layer.borderWidth = 1.0
        lineView2.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(lineView2)
        
        let lineView3 = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 1.0))
        lineView3.layer.borderWidth = 1.0
        lineView3.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(lineView3)
        
        let lineView4 = UIView(frame: CGRect(x: 0, y: 344, width: self.view.frame.width, height: 1.0))
        lineView4.layer.borderWidth = 1.0
        lineView4.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(lineView4)
        
        let lineView5 = UIView(frame: CGRect(x: 0, y: 388, width: self.view.frame.width, height: 1.0))
        lineView5.layer.borderWidth = 1.0
        lineView5.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(lineView5)
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Share something interesting..."{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            txtPost.text = "Share something interesting..."
            txtPost.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    @objc func changePicture(){
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
    
    
    
    @IBAction func PostButtonPressed(_ sender: UIButton) {
        
        guard imageView.image != nil else {
            lblStatus.isHidden = false
            self.lblStatus.text = "Please upload an image"
            return
        }
        
        if imageView.image == UIImage(named: "photo-largePixel"){
            lblStatus.isHidden = false
            self.lblStatus.text = "Please upload an image"
            return
        }
        

        guard
            let title = txtPost.text,
            let userID = Auth.auth().currentUser?.uid,
            let data = imageView.image!.jpegData(compressionQuality: 0.5)
            else {
                lblStatus.isHidden = false
                self.lblStatus.text = "Something wrong"
                return
            }
        let creationData = Int(NSDate().timeIntervalSince1970)
        
        var fileName = NSUUID().uuidString
        fileName.append(".png")
        
        let storageRef = Storage.storage().reference().child("post_images").child(fileName)
        
        SVProgressHUD.show()
        
        storageRef.putData(data, metadata: nil){ (metaFromStorage, error) in
        
            SVProgressHUD.dismiss()
            
            if error != nil {
                print("Error accured in uploading file")
                print(error.debugDescription)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else{
                    print(error.debugDescription)
                    return
                }
                let values = ["title" : title,
                              "creationDate" : creationData,
                              "likes" : 0,
                              "imageURL" : downloadURL.absoluteString,
                              "ownerUID" : userID
                             ] as [String: Any]
                
                let databaseRef = Database.database().reference().child("Posts").childByAutoId()
                
                SVProgressHUD.show()
                
                databaseRef.updateChildValues(values) { (err , ref) in
                    
                    SVProgressHUD.dismiss()
                    
                    self.initSet()
                    
                    if err != nil {
                        self.tabBarController?.selectedIndex = 0
                        print(err.debugDescription)
                        return
                    }
                    self.tabBarController?.selectedIndex = 0
                }
                self.tabBarController?.selectedIndex = 0
            })
        }
    }
    
    func initSet(){
        txtPost.text = "Share something interesting..."
        txtPost.textColor = UIColor.lightGray
        imageView.image = UIImage(named: "photo-largePixel")
        lblStatus.text = ""
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
