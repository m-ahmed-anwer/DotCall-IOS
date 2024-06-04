//
//  ForgotPasswordController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//
import FirebaseAuth
import UIKit

class ForgotPasswordController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.barStyle = .black
        
        otpButton.layer.cornerRadius = CGFloat(K.borderRadius)
        emailFeild.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0)
    }
    
    // MARK: - Button Actions
    
    @IBAction func ForgotButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard let email = emailFeild.text, !email.isEmpty else {
            alert(title: "Invalid ", message: "Please enter an email address.")
            return
        }
        
        if !isValidEmail(email: email){
            alert(title: "Email Validation", message: "Please enter a valid email.")
            return
        }
        
        
        LoadingManager.shared.showValidatingLoadingScreen()
        forgotPassword(email:email)
        
    }
    

    
}

// MARK: - Network Requests

extension ForgotPasswordController {
   
    private func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                LoadingManager.shared.hideLoadingScreen()
                self.alert(title: "Error resetting password", message: error.localizedDescription)
                return
            }
            LoadingManager.shared.hideLoadingScreen()
            self.navigationController?.popViewController(animated: true)
            self.alert(title: "Success", message: "Password reset email sent to \(email)")
        }
    }

}

// MARK: - UI Updates

extension ForgotPasswordController {
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func impactFeedback() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
