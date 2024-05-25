//
//  LoginViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//
import UIKit

class LoginViewController: UIViewController {
    
    static let shared = LoginViewController()
    
    @IBOutlet weak var inputstack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var phoneNumberFeild: UITextField!
    
    var countryCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberFeild.delegate = self
        let countryMenu = UIMenu(title: "Country Code", children: createCountryMenuItems())
        countryButton.menu = countryMenu
        navigationController?.navigationBar.barStyle = .black
        [passwordField, phoneNumberFeild].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
        addLeftPadding(to: passwordField)
        addLeftPadding(to: phoneNumberFeild)
        loginButton.layer.cornerRadius = CGFloat(K.borderRadius)
    }
    
    private func addLeftPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let phoneNumber = phoneNumberFeild.text, !phoneNumber.isEmpty, let password = passwordField.text, !password.isEmpty,  let _ = Int(phoneNumber)  else {
            
            alert(title: "Missing Information", message: "Please enter both your phone number and password.")
            
            return
        }
        
        // Validate password length
        if password.count < 6 {
            alert(title: "Password Validation", message: "Password must be 6 characters long.")
            return
        }
        var  finalPhoneNumber: String
        
        // Continue with login process
        if countryCode == "" {
            finalPhoneNumber = "+94\(phoneNumber)"
        } else {
            finalPhoneNumber = "\(countryCode)\(phoneNumber)"
        }
        
        LoadingManager.shared.showLoadingScreen()
        loginUser(finalPhoneNumber, password) { success, message in
            if success {
                AuthManager.shared.startAuth(phoneNumber: finalPhoneNumber) { [weak self] success, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        LoadingManager.shared.hideLoadingScreen()
                        if success {
                            self.performSegue(withIdentifier: "OTPtoCheck", sender: finalPhoneNumber)
                        } else {
                            self.alert(title: "Authentication Error", message: error != nil ? error!.localizedDescription:"Failed to start authentication process.")
                        }
                    }
                }
            } else {
                // Login failed, display the error message
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

extension LoginViewController: UITextFieldDelegate {
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

extension UIView {
    func addBottomBorder(withColor color: UIColor, thickness: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - thickness, width: self.frame.size.width, height: thickness)
        bottomBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}


extension LoginViewController{
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func loginUser(_ phoneNumber: String, _ password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/login")!
        
        let json: [String: Any] = [
            "phoneNumber": phoneNumber,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false, "Network error")
                    return
                }
                
                guard let data = data else {
                    print("No data in response")
                    completion(false, "No data in response")
                    return
                }
                
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
            
            task.resume()
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            completion(false, "Error creating JSON data")
        }
    }
    
}

extension LoginViewController{
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
