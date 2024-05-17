//
//  ForgotPasswordController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class ForgotPasswordController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fPasswordFeild: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    
    var countryCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fPasswordFeild.delegate = self
        
        let countryMenu = UIMenu(title: "Country Code", children: createCountryMenuItems())
       
        countryButton.menu = countryMenu
               
        
        navigationController?.navigationBar.barStyle = .black
        
        otpButton.layer.cornerRadius = CGFloat(K.borderRadius)
        fPasswordFeild.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0)
    }
    
    
    @IBAction func ForgotButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let phoneNumber = fPasswordFeild.text,
              let _ = Int(phoneNumber) else {
            // Show an alert if the phone number contains non-numeric characters
            let alert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid phone number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
            if success {
                AuthManager.shared.startAuth(phoneNumber: finalPhoneNumber) { [weak self] success, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        LoadingManager.shared.hideLoadingScreen()
                        if success {
                            self.performSegue(withIdentifier: "OTPToCheck", sender: finalPhoneNumber)
                        } else {
                            self.alert(title: "Authentication Error", message: error != nil ? error!.localizedDescription:"Failed to start authentication process.")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    LoadingManager.shared.hideLoadingScreen()
                    self.alert(title: "Login Failed", message: message ?? "Unknown error")
                }
            }
        }
        
        

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPtoCheck" {
            if let destinationVC = segue.destination as? LoginOTPController {
                if let phoneNumber = sender as? String {
                    destinationVC.phoneNumberText = phoneNumber
                }
            }
        }
    }

    
    
    func createCountryMenuItems() -> [UIMenuElement] {
        
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
    
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkUserByPhoneNumberToChangePassword(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
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
                        print("Response: \(json)")
                        
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

