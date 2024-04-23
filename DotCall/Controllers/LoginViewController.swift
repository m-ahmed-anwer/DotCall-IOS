//
//  LoginViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//
import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = "Cancel"
        loginButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
    
    }
}
