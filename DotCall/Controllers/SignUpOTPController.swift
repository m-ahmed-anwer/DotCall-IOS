//
//  SignUpOTPController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-29.
//


import AEOTPTextField

import UIKit

class SignUpOTPController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var resendText: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var OTPButton: UIButton!

    
    @IBOutlet weak var otpTextField: AEOTPTextField!
    
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
        performSegue(withIdentifier: "CreatetoCheck", sender: nil)
    }
    
}


extension SignUpOTPController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
}

