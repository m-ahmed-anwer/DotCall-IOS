//
//  SignupInformationController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class SignupInformationController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var nameFeild: UITextField!
    @IBOutlet weak var passwordFeild: UITextField!
    @IBOutlet weak var confirmPasswordFeild: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.barStyle = .black
        
        confirmButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        [emailFeild, nameFeild, passwordFeild, confirmPasswordFeild].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
    }
    
    // MARK: - Button Actions
    
    @IBAction func AllSetButtonPressed(_ sender: UIButton) {
        impactFeedback()
        
        guard let passwordText = passwordFeild.text, !passwordText.isEmpty,
              let confirmPasswordText = confirmPasswordFeild.text, !confirmPasswordText.isEmpty,
              let email = emailFeild.text, !email.isEmpty,
              let name = nameFeild.text, !name.isEmpty else {
            alert(title: "Missing Information", message: "Please enter your email, name, and passwords.")
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
        
        userEmail = email
        userName = name
        userPassword = passwordText
        
        LoadingManager.shared.showLoadingScreen()
        searchUser(email: email) { success, message in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    self.performSegue(withIdentifier: "CreatetoCheck",  sender: name)
                } else {
                    self.alert(title: "SignUp Failed", message: message ?? "Unknown error")
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatetoCheck" {
            if let destinationVC = segue.destination as? SignupViewController {
                if let name = sender as? String {
                    destinationVC.name = name
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
    
    private func searchUser( email: String ,completion: @escaping (Bool, String?) -> Void) {
        // Prepare the request URL
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/email")!
        
        // Prepare the request body
        let json: [String: Any] = [
            "email": email
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
