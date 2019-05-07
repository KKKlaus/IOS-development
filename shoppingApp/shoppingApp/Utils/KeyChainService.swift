//
//  KeyChainService.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation
import KeychainSwift


class KeyChainService{
    var _keyChain = KeychainSwift()
    var keyChain: KeychainSwift{
        get{
            return _keyChain
        }
        set{
            _keyChain = newValue
        }
    }
}
