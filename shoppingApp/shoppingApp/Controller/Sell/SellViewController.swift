//
//  SellViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SellViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        txtDescription.text = "Make some Description of the product..."
        txtDescription.textColor = UIColor.lightGray
        txtDescription.returnKeyType = .done
        txtDescription.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SellViewController.changePicture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func nameEditing(_ sender: Any) {
    }
    
    @IBAction func priceEditing(_ sender: Any) {
    }
    
    @IBAction func sellBtn(_ sender: UIButton) {
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
            let description = txtDescription.text,
            let name = txtName.text,
            let price = txtPrice.text,
            let userID = Auth.auth().currentUser?.uid,
            let data = imageView.image!.jpegData(compressionQuality: 0.5)
        else{
            lblStatus.isHidden = false
            self.lblStatus.text = "Something wrong"
            return
        }
        
        //MARK: -corner case
        if(name == ""){
            lblStatus.isHidden = false
            self.lblStatus.text = "Please Enter a name of the product :)"
            return
        }
        if(price == ""){
            lblStatus.isHidden = false
            self.lblStatus.text = "Please Enter price of the product :)"
            return
        }
        
        
        
        
        var fileName = NSUUID().uuidString
        fileName.append(".png")
        
        let storageRef = Storage.storage().reference().child("sell_images").child(fileName)
        SVProgressHUD.show()
        
        storageRef.putData(data, metadata: nil) { (metaFromStorage, error) in
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
                let values = ["description" : description,
                              "imageURL" : downloadURL.absoluteString,
                              "name" : name,
                              "ownerUID" : userID,
                              "price" : price
                ] as [String: Any]
                
                let databaseRef = Database.database().reference().child("Products").childByAutoId()
                
                SVProgressHUD.show()
                
                databaseRef.updateChildValues(values) { (err , ref) in
                    
                    SVProgressHUD.dismiss()
                    
                    self.initSet()
                    
                    if err != nil {
                        print(err.debugDescription)
                        return
                    }
                    // MARK: -Back to home
//                    let title = String(describing: MenuType)
//                    let HomeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
//                    self.addChild(HomeVC)
//                    HomeVC.view.frame = self.view.frame
//                    self.view.addSubview(HomeVC.view)
//                    HomeVC.didMove(toParent: self)
                    
                    
                }
                
                
            })
            
        }
        
        
        
    }
    
    func initSet(){
        txtDescription.text = "Make some Description of the product..."
        txtDescription.textColor = UIColor.lightGray
        imageView.image = UIImage(named: "photo-largePixel")
        lblStatus.text = ""
        txtName.text = ""
        txtPrice.text = ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Make some Description of the product..."{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            txtDescription.text = "Make some Description of the product..."
            txtDescription.textColor = UIColor.lightGray
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
