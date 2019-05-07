//
//  HomeViewController.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/26/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Kingfisher

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postData = [PostModel]()
    var userData = [UserModel]()
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        SVProgressHUD.show()
        let databaseRef = Database.database().reference()
        databaseRef.child("Posts").observe(.childAdded) { (snapShot) in
            let key = snapShot.key
            guard let postDict = snapShot.value as? Dictionary<String, AnyObject> else {return}
            let post = PostModel(postId: key, dictionary: postDict)
            self.postData.insert(post, at: 0)
            self.table.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
/*-----------------------Way1: -------------------------*/
/*get image by storageRef.getdata() (Firebase API), but it load image everytime and slowly*/
/*
        let storageRef = Storage.storage().reference(forURL: rowData[indexPath.row].imageURL)
        storageRef.getData(maxSize: 1024*1024*1024) { (data, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }else{
                let image = UIImage(data: data!)
                cell.postImage.image = image
            }
        }
 */
        
/*-----------------------Way2: -------------------------*/
/*get image by kf.setImage() (Kingfisher API), but it load image the first time and save, make loading faster next time*/
        
        let url = URL(string: postData[indexPath.row].imageURL!)
        cell.postImage.kf.setImage(with: url)
        cell.postLabel.text = postData[indexPath.row].title
        
        //get uid from postdata and get userdata from this uid => get the profileImage and profileName
        let uid = postData[indexPath.row].ownerUID!
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            let user = UserModel(userId: uid, dictionary: dict as! Dictionary<String, AnyObject>)
            let profileName = user.name!
            let profileURL = URL(string: user.imageURL!)
            cell.profileName.text = profileName
            cell.profileImage.kf.setImage(with: profileURL)
        }
        
        return cell
    }
    
    
    
    


}
