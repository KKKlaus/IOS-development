//
//  ScanViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision
import FirebaseMLCommon

class ScanViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblStatus: UILabel!
    
    lazy var vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        txtView.text = "Put product barcode to scan..."
        txtView.isEditable = false
        txtView.textColor = UIColor.lightGray
        txtView.returnKeyType = .done
        txtView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScanViewController.changePicture))
        myImage.addGestureRecognizer(tapGesture)
        myImage.isUserInteractionEnabled = true
        
    }
    
    @IBAction func scanBtn(_ sender: UIButton) {
        guard myImage.image != nil else {
            lblStatus.isHidden = false
            self.lblStatus.text = "Please upload an image"
            return
        }
        
        if myImage.image == UIImage(named: "photo-largePixel"){
            lblStatus.isHidden = false
            self.lblStatus.text = "Please upload an image"
            return
        }
        
        let format = VisionBarcodeFormat.all
        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
        
        let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
        
        guard let image = myImage.image else { return }
        let visionImage = VisionImage(image: image)
        
        
        barcodeDetector.detect(in: visionImage) { barcodes, error in
            guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                let errorString = error?.localizedDescription
                self.txtView.text = "Somethong wrong: \(String(describing: errorString))"
                return
            }
            for barcode in barcodes {
                print("entered")
                let corners = barcode.cornerPoints
                
                let displayValue = barcode.displayValue
                let rawValue = barcode.rawValue
                
                self.txtView.textColor = .black
                self.txtView.text = "Corners: \(String(describing: corners!)) \n\n DisplayValue: \(String(describing: displayValue!)) \n\n RawValue: \(String(describing: rawValue!))"
                
            }
        }
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
        myImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
