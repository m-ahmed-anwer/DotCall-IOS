//
//  ResetPasswordConrttoller.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-28.
//

import UIKit

class ResetPasswordConrttoller: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        // Set navigation bar style and corner radius for reset button
        navigationController?.navigationBar.barStyle = .black
        resetButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        // Add bottom border to text fields
        [newPassword, confirmPassword].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
    }
    
    // MARK: - Actions
    
    @IBAction func ResetButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let newPasswordText = newPassword.text, !newPasswordText.isEmpty,
              let confirmPasswordText = confirmPassword.text, !confirmPasswordText.isEmpty else {
            // Show an alert if either field is empty
            alert(title: "Missing Information", message: "Please enter both your new and confirm passwords.")
            return
        }

        guard newPasswordText.count >= 6 else {
            // Show an alert if the new password is too short
            alert(title: "Password Validation", message: "Password must be at least 6 characters long.")
            return
        }

        guard newPasswordText == confirmPasswordText else {
            // Show an alert if passwords do not match
            alert(title: "Password Mismatch", message: "New password and confirm password do not match.")
            return
        }

        // If all validations pass, continue with the reset password process
        print("Password Reset Successful")
    }
    
    // MARK: - Helper Methods
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
