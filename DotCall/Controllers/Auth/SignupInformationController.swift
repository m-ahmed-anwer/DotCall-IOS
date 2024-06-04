//
//  SignupInformationController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit
import FirebaseAuth

class SignupInformationController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameFeild: UITextField!
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var nameFeild: UITextField!
    @IBOutlet weak var passwordFeild: UITextField!
    @IBOutlet weak var confirmPasswordFeild: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    private var loadingView: UIView?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.barStyle = .black
        confirmButton.layer.cornerRadius = CGFloat(K.borderRadius)
        [usernameFeild,emailFeild, nameFeild, passwordFeild, confirmPasswordFeild].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
    }
    
    // MARK: - Button Actions
    
    @IBAction func AllSetButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard let passwordText = passwordFeild.text, !passwordText.isEmpty,
              let confirmPasswordText = confirmPasswordFeild.text, !confirmPasswordText.isEmpty,
              let username = usernameFeild.text, !username.isEmpty,
              let email = emailFeild.text, !email.isEmpty,
              let name = nameFeild.text, !name.isEmpty else {
            alert(title: "Missing Information", message: "Please enter your username, email, name, and passwords.")
            return
        }
        
        
        
        guard username.count >= 6 else {
            alert(title: "Username Validation", message: "Username must be at least 6 characters long.")
            return
        }
        
        guard isValidEmail(email) else {
            alert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        guard passwordText.count >= 6 else {
            alert(title: "Password Validation", message: "Password must be at least 6 characters long.")
            return
        }
        
        guard passwordText == confirmPasswordText else {
            alert(title: "Password Mismatch", message: "Password and confirm password do not match.")
            return
        }
        
        LoadingManager.shared.showValidatingLoadingScreen()
        searchUser(username: username) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.createUserAccountAndSendVerificationEmail(email: email, password: passwordText, name: name, username: username)
                } else {
                    LoadingManager.shared.hideLoadingScreen()
                    self.alert(title: "Sign Up Failed", message: message ?? "Unknown error")
                }
            }
        }
    }
    
}

// MARK: - Helper Methods

extension SignupInformationController{
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func searchUser( username: String ,completion: @escaping (Bool, String?) -> Void) {
        // Prepare the request URL
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/username"+username)!
        
        // Prepare the request body
        let json: [String: Any] = [
            "username": username
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Create the request
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
    
    private func createUserAccountAndSendVerificationEmail(email: String, password: String, name: String, username:String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                LoadingManager.shared.hideLoadingScreen()
                self.alert(title: "Error creating user:", message: error!.localizedDescription)
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                
                if let error = error {
                    LoadingManager.shared.hideLoadingScreen()
                    self.alert(title: "Error setting display name:", message: error.localizedDescription)
                    return
                }
                
                Auth.auth().currentUser?.sendEmailVerification { error in
                    if let error = error {
                        self.alert(title: "Error sending email verification:", message: error.localizedDescription)
                    } else {
                        LoadingManager.shared.hideLoadingScreen()
                        self.registerUser(name: name, username: username, email: email, password: password)
                    }
                }
            }
        }
    }
    
    private func registerUser(name: String, username: String, email: String, password: String) {
            // Prepare the request URL
            let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/signup")!
            
            // Prepare the request body
            let json: [String: Any] = [
                "name" : name,
                "email" : email,
                "username" : username,
                "password" : password
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
                        self.alert(title: "Error:", message: error.localizedDescription)
                        return
                    }
                    
                    guard let data = data else {
                        self.alert(title: "Error:", message: "No data in response")
                        return
                    }
                    
                    do {
                        if try JSONSerialization.jsonObject(with: data, options: []) is [String: Any] {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "confirmationCheck", sender: name)
                            }
                        }
                    } catch {
                        self.alert(title: "Error parsing JSON:", message: error.localizedDescription)
                    }
                }
                task.resume()
            } catch {
                alert(title: "Error creating JSON:", message: error.localizedDescription)
            }
        }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmationCheck" {
            if let destinationVC = segue.destination as? SignupConfirmationController {
                if let name = sender as? String {
                    if let confirmationText = destinationVC.confirmationText {
                        confirmationText.text = "Hello \(name)! You are in."
                    }
                }
            }
        }
    }



}
