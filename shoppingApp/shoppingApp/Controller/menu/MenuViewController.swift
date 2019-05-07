//
//  MenuViewController.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case Home
    case Cart
    case Profile
    case Sell
    case Scan
}


class MenuViewController: UITableViewController {

     var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            self?.didTapMenuType?(menuType)
        }
    }
}
