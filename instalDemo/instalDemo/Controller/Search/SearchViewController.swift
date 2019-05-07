//
//  SearchViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 4/9/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    
/*-------Way to make a search: ------ */
/*
 * use two same array,one for init, another for updating (eg: useeData & updateUserData)
 * in viewDidLoad() function, we initializa userData, but what we render everytime is updateUserData
 * in searchBar() function, we use array.filter() method to implement our search, here I think `contains` is ok
 *
 */
    var userData = [UserModel]()
    var updateUserData = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
        
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").observe(.childAdded) { (snapShot) in
            let key = snapShot.key
            guard let UserDict = snapShot.value as? Dictionary<String, AnyObject> else {return}
            let User = UserModel(userId: key, dictionary: UserDict)
            self.userData.append(User)
            
            self.updateUserData = self.userData
            self.searchTable.reloadData()
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updateUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell
/*-----------------------Way1: -------------------------*/
/*get image by storageRef.getdata() (Firebase API), but it load image everytime and slowly*/
/*
        let storageRef = Storage.storage().reference(forURL:updateUserData[indexPath.row].imageURL)
        storageRef.getData(maxSize: 1024*1024*1024) { (data, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }else{
                let image = UIImage(data: data!)
                cell.searchImage.image = image
            }
        }
*/

/*-----------------------Way2: -------------------------*/
/*get image by kf.setImage() (Kingfisher API), but it load image the first time and save, make loading faster next time*/
        let url = URL(string: updateUserData[indexPath.row].imageURL!)
        cell.searchImage.kf.setImage(with: url)
        cell.searchName.text = updateUserData[indexPath.row].name
        cell.searchEmail.text = updateUserData[indexPath.row].email
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            updateUserData = userData
            searchTable.reloadData()
            return
        }
        updateUserData = userData.filter({ (UserModel) -> Bool in
            UserModel.name.lowercased().contains(searchText.lowercased())
        })
        searchTable.reloadData()
    }
}
