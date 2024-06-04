//
//  SignUpOTPController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-29.
//

import AEOTPTextField
import UIKit

class SignUpOTPController: UIViewController, UITextFieldDelegate {
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

    // MARK: - Actions
    @IBAction func OTPButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard smsCode != "" else {
            return
        }
        verify(code: smsCode)
    }
}

// MARK: - AEOTPTextFieldDelegate
extension SignUpOTPController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        smsCode = code
        verify(code: code)
    }
}

// MARK: - Private Methods
extension SignUpOTPController {
    
    private func verify(code: String) {
        LoadingManager.shared.showLoadingScreen()
        AuthManager.shared.verifyCode(smsCode: code) { success, error in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    self.signupUser(name: userName, email: userEmail, password: userPassword, phoneNumber: userPhoneNumber)
                } else {
                    let alert = UIAlertController(title: "Authentication Error", message: error != nil ? error?.localizedDescription : "Failed to start authentication process.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func signupUser(name: String, email: String, password: String, phoneNumber: String) {
        // Prepare the request URL
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/signup")!
        
        // Prepare the request body
        let json: [String: Any] = [
            "name" : name,
            "email" : email,
            "password" : password,
            "phoneNumber" : phoneNumber
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Perform the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data in response")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userData = json["user"] as? [String: Any] {
                        // Save user data
                        UserProfile.shared.generalProfile.id = userData["_id"] as? String
                        UserProfile.shared.generalProfile.name = userData["name"] as? String
                        UserProfile.shared.generalProfile.email = userData["email"] as? String
                        UserProfile.shared.generalProfile.phoneNumber = userData["phoneNumber"] as? String
                        if let settings = userData["generalSettings"] as? [String: Any] {
                           UserProfile.shared.settingsProfile.notification = settings["notification"] as? Bool
                           UserProfile.shared.settingsProfile.faceId = settings["faceId"] as? Bool
                           UserProfile.shared.settingsProfile.haptic = settings["haptic"] as? Bool
                       }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
        }
    }

    
    
    private func saveUserData() {
        let defaults = UserDefaults.standard
        defaults.set(UserProfile.shared.generalProfile.id, forKey: "userId")
        defaults.set(UserProfile.shared.generalProfile.name, forKey: "userName")
        defaults.set(UserProfile.shared.generalProfile.email, forKey: "userEmail")
        defaults.set(UserProfile.shared.generalProfile.phoneNumber, forKey: "userPhoneNumber")
        defaults.set(UserProfile.shared.settingsProfile.notification, forKey: "notification")
        defaults.set(UserProfile.shared.settingsProfile.faceId, forKey: "faceId")
        defaults.set(UserProfile.shared.settingsProfile.haptic, forKey: "haptic")
    }
    
}

