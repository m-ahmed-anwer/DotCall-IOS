//
//  File.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-28.
//

import UIKit

class ResetPasswordConrttoller: UIViewController {

    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        resetButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        [newPassword, confirmPassword].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
    }
    
    
    @IBAction func ResetButtonPressed(_ sender: UIButton) {
        guard let newPasswordText = newPassword.text, !newPasswordText.isEmpty,
          let confirmPasswordText = confirmPassword.text, !confirmPasswordText.isEmpty else {
            
            alert(title: "Missing Information", message: "Please enter both your new and confirm passwords.")
          
            return
        }

        guard newPasswordText.count >= 6 else {
            alert(title: "Password Validation", message: "Password must be at least 6 characters long.")
            return
        }

        guard newPasswordText == confirmPasswordText else {
            alert(title: "Password Mismatch", message: "New password and confirm password do not match.")
            return
        }

        // If all validations pass, continue with the reset password process
        print("Password Reset Successful")
    }
    
    
}


extension ResetPasswordConrttoller{
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
