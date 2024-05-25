//
//  OTPVerification.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//


import UIKit
import AEOTPTextField

class LoginOTPController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var resendText: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var OTPButton: UIButton!
    @IBOutlet weak var otpTextField: AEOTPTextField!
    
    // MARK: - Properties
    
    var smsCode: String = ""
    var phoneNumberText: String = ""
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumber.text = phoneNumberText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.barStyle = .black
        
        otpTextField.otpDelegate = self
        otpTextField.configure(with: 6)
        
        // Set attributed text for "Resend" label
        let text = "Didn't receive the code? Resend"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Resend")
        attributedString.addAttribute(.foregroundColor, value: UIColor.link, range: range)
        resendText.attributedText = attributedString
        
        // Set corner radius for OTP button
        OTPButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        // Set underline style for phone number label
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "+94 768242884", attributes: underlineAttribute)
        phoneNumber.attributedText = underlineAttributedString
    }

    private func verify(code: String) {
        LoadingManager.shared.showLoadingScreen()
        AuthManager.shared.verifyCode(smsCode: code) { success, error in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    print("Sign in successful")
                } else {
                    let alert = UIAlertController(title: "Authentication Error", message: error != nil ? error?.localizedDescription : "Failed to start authentication process.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Button Actions
    
    @IBAction func OTPButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard smsCode != "" else {
            return
        }
        verify(code: smsCode)
    }

}

// MARK: - AEOTPTextFieldDelegate

extension LoginOTPController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        smsCode = code
        verify(code: smsCode)
    }
}

// MARK: - Private Helper Methods

extension LoginOTPController {
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
