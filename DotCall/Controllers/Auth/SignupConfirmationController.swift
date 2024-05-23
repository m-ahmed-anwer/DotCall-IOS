//
//  SignupConfirmationController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class SignupConfirmationController: UIViewController {
    
    @IBOutlet weak var completeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        
        completeButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
    }
}


