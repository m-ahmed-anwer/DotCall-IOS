//
//  AuthManager.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-30.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    var isAccountCreated = false
    
    func resetState() {
            isAccountCreated = false
        }
}
