//
//  ForgotPasswordController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class ForgotPasswordController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fPasswordFeild: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    
    // MARK: - Properties
    
    var countryCode = ""
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        fPasswordFeild.delegate = self
        
        let countryMenu = UIMenu(title: "Country Code", children: createCountryMenuItems())
        countryButton.menu = countryMenu
        
        navigationController?.navigationBar.barStyle = .black
        
        otpButton.layer.cornerRadius = CGFloat(K.borderRadius)
        fPasswordFeild.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0)
    }
    
    // MARK: - Button Actions
    
    @IBAction func ForgotButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard let phoneNumber = fPasswordFeild.text,
              let _ = Int(phoneNumber) else {
            // Show an alert if the phone number contains non-numeric characters
            alert(title: "Invalid Phone Number", message: "Please enter a valid phone number.")
            return
        }
        
        var  finalPhoneNumber: String
        if countryCode == "" {
            finalPhoneNumber = "+94\(phoneNumber)"
        } else {
            finalPhoneNumber = "\(countryCode)\(phoneNumber)"
        }
        
        LoadingManager.shared.showLoadingScreen()
        checkUserByPhoneNumberToChangePassword(phoneNumber: finalPhoneNumber) { success, message in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    self.performSegue(withIdentifier: "OTPToCheck", sender: finalPhoneNumber)
                } else {
                    self.alert(title: "Authentication Error", message: message ?? "Unknown error")
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPtoCheck" {
            if let destinationVC = segue.destination as? LoginOTPController {
                if let phoneNumber = sender as? String {
                    destinationVC.phoneNumberText = phoneNumber
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createCountryMenuItems() -> [UIMenuElement] {
        return countries.map { country in
            let components = country.components(separatedBy: " ")
            let countryCode = components.last ?? ""
            
            return UIAction(title: country, handler: { [weak self] action in
                // Set the button title to the selected country
                self?.countryButton.setTitle(country, for: .normal)
                self?.countryCode = countryCode // Update countryCode here
                
                UserDefaults.standard.set(countryCode, forKey: "selectedCountryCode")
            })
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ForgotPasswordController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow backspace
        guard string != "" else {
            return true
        }
        
        // Check if the replacement string contains only numbers
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let stringCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: stringCharacterSet)
    }
}

// MARK: - Network Requests

extension ForgotPasswordController {
    private func checkUserByPhoneNumberToChangePassword(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        // Prepare the request URL
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/passwordChange")!
        
        // Prepare the request body
        let json: [String: Any] = [
            "phoneNumber": phoneNumber
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
                    completion(false, "Network error")
                    return
                }
                
                // Check if the response contains data
                guard let data = data else {
                    print("No data in response")
                    completion(false, "No data in response")
                    return
                }
                
                // Parse the JSON response
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        // Check the success status in the response
                        if let success = json["success"] as? Int, success == 1 {
                            // Login successful
                            completion(true, nil)
                        } else {
                            // Login failed, get the error message
                            if let message = json["message"] as? String {
                                completion(false, message)
                            } else {
                                completion(false, "Unknown error")
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(false, "Error parsing JSON")
                }
            }
            
            // Execute the task
            task.resume()
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            completion(false, "Error creating JSON data")
        }
    }
}

// MARK: - UI Updates

extension ForgotPasswordController {
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
