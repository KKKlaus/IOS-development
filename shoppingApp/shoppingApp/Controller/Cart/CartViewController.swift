//
//  CartViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Kingfisher

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var txtSumPrice: UILabel!
    var sum = 0.0
    
    var cartProductData = [CartProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        SVProgressHUD.show()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        
        //check if cart has item
        databaseRef.child("Carts").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() == false{
                self.txtSumPrice.text = "No Item"
                SVProgressHUD.dismiss()
                return
            }
        }
        databaseRef.child("Carts").child(userID).observe(.childAdded) { (snapShot) in
            let key = snapShot.key
            guard let productDict = snapShot.value as? Dictionary<String, AnyObject> else {return}
            let product = CartProductModel(prodcutID: key, dictionary: productDict)
            product.prodcutID = key
            self.cartProductData.insert(product, at: 0)
            SVProgressHUD.dismiss()
            self.table.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CartTableViewCell", owner: self, options: nil)?.first as! CartTableViewCell
        
        let url = URL(string: cartProductData[indexPath.row].imageURL!)
        cell.profuctImage.kf.setImage(with: url)
        cell.productName.text = cartProductData[indexPath.row].name
        cell.productPrice.text = cartProductData[indexPath.row].price
        cell.productCount.text = cartProductData[indexPath.row].count
        cell.productId.text = cartProductData[indexPath.row].prodcutID
        let count = Double(cartProductData[indexPath.row].count!)
        let eachPrice = Double(cartProductData[indexPath.row].price!)
        sum = sum + count! * eachPrice!
        if(indexPath.row == cartProductData.count - 1){
            sum = sum.roundTo(places: 2)
            txtSumPrice.text = "Cart total: $\(sum)"
        }
        if let btnDelete = cell.contentView.viewWithTag(102) as? UIButton {
            print("btnDelete: \(btnDelete)")
            btnDelete.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
        }
        return cell
    }
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: table)
        guard let indexPath = table.indexPathForRow(at: point) else {
            return
        }
        //process the change of TotalPrice
        let count = Double(cartProductData[indexPath.row].count!)
        let eachPrice = Double(cartProductData[indexPath.row].price!)
        print("count: \(String(describing: count))")
        print("eachPrice: \(String(describing: eachPrice))")
        sum = sum - count! * eachPrice!
        sum = sum.roundTo(places: 2)
        txtSumPrice.text = "Cart total: $\(sum)"
        
        
        cartProductData.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .left)

    }
    
    

}

extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
