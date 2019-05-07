//
//  Extension.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/25/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation


extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
