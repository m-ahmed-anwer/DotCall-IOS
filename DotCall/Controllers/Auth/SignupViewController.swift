//
//  SignupViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var greetingText: UILabel!
    
    // MARK: - Properties
    
    var countryCode = ""
    var name: String = ""
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        greetingText.text = "Hello \(name)!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        phoneNumberField.delegate = self
        let countryMenu = UIMenu(title: "Country Code", children: createCountryMenuItems())
        countryButton.menu = countryMenu
        navigationController?.navigationBar.barStyle = .black
        otpButton.layer.cornerRadius = CGFloat(K.borderRadius)
        phoneNumberField.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0)
    }
    
    private func createCountryMenuItems() -> [UIMenuElement] {
        return countries.map { country in
            let components = country.components(separatedBy: " ")
            let countryCode = components.last ?? ""
            
            return UIAction(title: country, handler: { [weak self] action in
                self?.countryButton.setTitle(country, for: .normal)
                self?.countryCode = countryCode
                UserDefaults.standard.set(countryCode, forKey: "selectedCountryCode")
            })
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard let phoneNumber = phoneNumberField.text, !phoneNumber.isEmpty,
              let _ = Int(phoneNumber)  else {
            alert(title: "Missing Information", message: "Please enter your phone number.")
            return
        }
        
        var finalPhoneNumber: String
        
        if countryCode == "" {
            finalPhoneNumber = "+94\(phoneNumber)"
        } else {
            finalPhoneNumber = "\(countryCode)\(phoneNumber)"
        }
        
        LoadingManager.shared.showLoadingScreen()
        checkUserByPhoneNumber(phoneNumber: finalPhoneNumber) { success, message in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                
                if success {
                    userPhoneNumber = finalPhoneNumber
                    self.performSegue(withIdentifier: "SignUpToCheck",  sender: finalPhoneNumber)
                } else {
                    self.alert(title: "Login Failed", message: message ?? "Unknown error")
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToCheck" {
            if let destinationVC = segue.destination as? SignUpOTPController,
               let phoneNumber = sender as? String {
                destinationVC.phoneNumberText = phoneNumber
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "" else {
            return true
        }
        
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let stringCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: stringCharacterSet)
    }
}

// MARK: - Helper Extensions

extension SignupViewController{
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    private func impactFeedback() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}


// MARK: - Private Helper Methods

private extension SignupViewController{

    private func checkUserByPhoneNumber(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        // Prepare the request URL
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/phoneNumber")!
        
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
                        
                        if let success = json["success"] as? Int, success == 1 {
                            // Parse and store user data
                            if let userData = json["user"] as? [String: Any] {
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
                            self.saveUserData()
                            completion(true, nil)
                        } else {
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
