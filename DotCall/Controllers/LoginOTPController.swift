//
//  OTPVerification.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class OTPVerificationController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resendText: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var OTPButton: UIButton!
    
    @IBOutlet weak var code1: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code4: UITextField!
    @IBOutlet weak var code5: UITextField!
    @IBOutlet weak var code6: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        // Add bottom border to text fields
        [code1, code2, code3, code4, code5, code6].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
        
        // Set delegates for text fields
        [code1, code2, code3, code4, code5, code6].forEach { $0?.delegate = self }
        
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
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the replacement string is a single digit
        guard string.count == 1, let digit = Int(string) else {
            // Handle cases where the user tries to delete characters or paste more than one character
            if string.isEmpty {
                textField.text = ""
                if let prevField = view.viewWithTag(textField.tag - 1) as? UITextField {
                    prevField.becomeFirstResponder()
                }
            }
            return false
        }

        // Update current text field with the entered digit
        textField.text = String(digit)

        // Calculate the tag for the next text field
        let nextFieldTag = textField.tag + 1

        // Move focus to the next text field if available
        if let nextField = view.viewWithTag(nextFieldTag) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Reached the last text field, resign the keyboard
            textField.resignFirstResponder()
        }

        return false
    }



}
