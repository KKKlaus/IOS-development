//
//  CartTableViewCell.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/23/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var profuctImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        sender.pulsate()
        let productID = productId.text!
        guard  let user = Auth.auth().currentUser else { return }
        
        let id = user.uid
        let databaseRef = Database.database().reference().child("Carts").child(id).child(productID)
        databaseRef.setValue(nil)
    }
    
    @IBAction func addCountBtn(_ sender: UIButton) {
        let productID = productId.text!
        guard  let user = Auth.auth().currentUser else { return }
        
        let id = user.uid
        let databaseRef = Database.database().reference().child("Carts").child(id).child(productID)
        databaseRef.observe(.value) { (snapshot) in
//            guard let productDict = snapshot.value as? Dictionary<String, AnyObject> else {return}
//            let prevCount = productDict["count"]!
//            let curCount = Int(prevCount as! String)!
//            databaseRef.child("count").setValue(curCount + 1)
        }
        
    }
    @IBAction func minusCountBtn(_ sender: UIButton) {
        
    }
}

