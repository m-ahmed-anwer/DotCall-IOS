//
//  LoginViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    
    static let shared = LoginViewController()
    
    @IBOutlet weak var inputstack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFeild: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        [passwordField, emailFeild].forEach { $0?.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0) }
        addLeftPadding(to: passwordField)
        addLeftPadding(to: emailFeild)
        loginButton.layer.cornerRadius = CGFloat(K.borderRadius)
    }
    
    private func addLeftPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @IBAction func showForgetPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "forgetPassCheck", sender: nil)
    }
    
    
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let email = emailFeild.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            alert(title: "Missing Information", message: "Please enter both your email and password.")
            return
        }
        
        if !isValidEmail(email: email){
            alert(title: "Email Validation", message: "Please enter a valid email.")
            return
        }
        
        if password.count < 6 {
            alert(title: "Password Validation", message: "Password must be 6 characters long.")
            return
        }
        
        
        
        
        LoadingManager.shared.showValidatingLoadingScreen()
        loginUser(email, password) { success, message in
            if success {
                self.loginFirebaseUser(email: email, password: password)
            } else {
                DispatchQueue.main.async {
                    LoadingManager.shared.hideLoadingScreen()
                    self.alert(title: "Login Failed", message: message ?? "Unknown error")
                }
            }
        }
        
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
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func loginFirebaseUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let _ = authResult?.user, error == nil else {
                LoadingManager.shared.hideLoadingScreen()
                self.alert(title:"Error Login" ,message:error!.localizedDescription)
                return
            }

            if let user = Auth.auth().currentUser {
                LoadingManager.shared.hideLoadingScreen()
                if !user.isEmailVerified {
                    self.alert(title:"Verification Failed" ,message:"Please verify the email, the email verification link has been sent.")
                }else{
                    self.saveUserData()
                }
            }
        }
    }
    
    private func loginUser(_ email: String, _ password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/users/login")!
        
        let json: [String: Any] = [
            "email": email,
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
                                   UserProfile.shared.generalProfile.username = userData["username"] as? String
                                   UserProfile.shared.generalProfile.token = userData["token"] as? String
                                   
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
        defaults.set(UserProfile.shared.generalProfile.username, forKey: "userUsername")
        defaults.set(UserProfile.shared.generalProfile.token, forKey: "token")
        defaults.set(UserProfile.shared.settingsProfile.notification, forKey: "notification")
        defaults.set(UserProfile.shared.settingsProfile.faceId, forKey: "faceId")
        defaults.set(UserProfile.shared.settingsProfile.haptic, forKey: "haptic")
    }
}
