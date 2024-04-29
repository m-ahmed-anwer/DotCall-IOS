//
//  SignupInformationController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class SignupInformationController: UIViewController {
    
    
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var nameFeild: UITextField!
    @IBOutlet weak var passwordFeild: UITextField!
    @IBOutlet weak var confirmPasswordFeild: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        
        confirmButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        [emailFeild, nameFeild, passwordFeild, confirmPasswordFeild].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
        
        
    }
}
