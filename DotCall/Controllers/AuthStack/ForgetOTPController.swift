//
//  ForgetOTPController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-29.
//


import AEOTPTextField

import UIKit

class ForgetOTPController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resendText: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var OTPButton: UIButton!
    
    @IBOutlet weak var otpTextField: AEOTPTextField!
    
    var smsCode:String = ""
    var phoneNumberText: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumber.text = phoneNumberText
    }


    override func viewDidLoad() {
       super.viewDidLoad()
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

    @IBAction func OTPButtonPressed(_ sender: UIButton) {
        guard smsCode != "" else {
            return
        }
        verify(code: smsCode)
    }
    

    
}


extension ForgetOTPController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        smsCode = code
        verify(code: code)
    }
}


extension ForgetOTPController{
    func verify(code: String){
        LoadingManager.shared.showLoadingScreen()
        AuthManager.shared.verifyCode(smsCode: code) { success, error in
            LoadingManager.shared.hideLoadingScreen()
            if success {
                self.performSegue(withIdentifier: "ResetPasswordToCheck", sender: nil)
            } else {
                let alert = UIAlertController(title: "Authentication Error", message: error != nil ? error?.localizedDescription:"Failed to start authentication process.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }

    }
}

