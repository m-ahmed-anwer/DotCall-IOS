//
//  HomeViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-01.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func SignOut(_ sender: UIButton) {
        signOutUser()
    }
}

func signOutUser() {
    do {
        try Auth.auth().signOut()
        print("sign out successfully")
    } catch let error as NSError {
        print("Error signing out: \(error.localizedDescription)")
    }
}


