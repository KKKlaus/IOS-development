//
//  HomeTableViewCell.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToCartButton(_ sender: UIButton) {
        sender.pulsate()
        guard
            let productid = productID.text,
            let description = productDescription.text,
            let name = productName.text,
            let price = productPrice.text,
            let userID = Auth.auth().currentUser?.uid,
            let data = productImage.image!.jpegData(compressionQuality: 0.5)
            else{
                print("something wrong")
                return
            }
        
        var fileName = NSUUID().uuidString
        fileName.append(".png")
        
        let storageRef = Storage.storage().reference().child("carts_images").child(fileName)
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
                             "count" : "1",
                             "price" : price
                ] as [String: Any]
                
                
                
                let databaseRef = Database.database().reference().child("Carts").child(userID).child(productid)
                
                SVProgressHUD.show()
                databaseRef.updateChildValues(values) { (err , ref) in
                    
                    SVProgressHUD.dismiss()
                    
                    if err != nil {
                        print(err.debugDescription)
                        return
                    }
                }
                
                
            })
        }
        
        
    }
    
}


extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
