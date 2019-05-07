//
//  KeyChainSwiftService.swift
//  instalDemo
//
//  Created by Zihao Lin on 3/25/19.
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
