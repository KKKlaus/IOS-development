//
//  HomeViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Kingfisher

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let transiton = SlideInTransition()
    var topView: UIView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var productData = [ProductModel]()
    var updateProductData = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        
        SVProgressHUD.show()
        let databaseRef = Database.database().reference()
        databaseRef.child("Products").observe(.childAdded) { (snapShot) in
            let key = snapShot.key
            guard let productDict = snapShot.value as? Dictionary<String, AnyObject> else {return}
            let product = ProductModel(prodcutID: key, dictionary: productDict)
            product.prodcutID = key
            self.productData.insert(product, at: 0)
            
            self.updateProductData = self.productData
            self.table.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updateProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        cell.backgroundColor = .white
        let url = URL(string: updateProductData[indexPath.row].imageURL!)
        cell.productImage.kf.setImage(with: url)
        cell.productName.text = updateProductData[indexPath.row].name
        cell.productPrice.text = String(updateProductData[indexPath.row].price!)
        cell.productDescription.text = updateProductData[indexPath.row].description
        cell.productID.text = updateProductData[indexPath.row].prodcutID
        
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            updateProductData = productData
            table.reloadData()
            return
        }
        updateProductData = productData.filter({ (ProductModel) -> Bool in
            ProductModel.name.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    
    

    
    // Process Side Menu :)
    @IBAction func MenuBtnPressed(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .Cart:
            let CartVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Cart")
            self.addChild(CartVC)
            CartVC.view.frame = self.view.frame
            self.view.addSubview(CartVC.view)
            CartVC.didMove(toParent: self)
        case .Profile:
            let ProfileVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Profile")
            self.addChild(ProfileVC)
            ProfileVC.view.frame = self.view.frame
            self.view.addSubview(ProfileVC.view)
            ProfileVC.didMove(toParent: self)
        case .Sell:
            let SellVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Sell")
            self.addChild(SellVC)
            SellVC.view.frame = self.view.frame
            self.view.addSubview(SellVC.view)
            SellVC.didMove(toParent: self)
        case .Scan:
            let ScanVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Scan")
            self.addChild(ScanVC)
            ScanVC.view.frame = self.view.frame
            self.view.addSubview(ScanVC.view)
            ScanVC.didMove(toParent: self)
        default:
            let HomeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
            self.addChild(HomeVC)
            HomeVC.view.frame = self.view.frame
            self.view.addSubview(HomeVC.view)
            HomeVC.didMove(toParent: self)
        }
    }
    
}
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
    
}
