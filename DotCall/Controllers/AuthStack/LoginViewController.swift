//
//  LoginViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//
import UIKit

class LoginViewController: UIViewController {
    
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
    
    func addLeftPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberFeild.text, !phoneNumber.isEmpty, let password = passwordField.text, !password.isEmpty,  let _ = Int(phoneNumber)  else {
            let alert = UIAlertController(title: "Missing Information", message: "Please enter both your phone number and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Validate password length
        if password.count < 6 {
            let alert = UIAlertController(title: "Password Validation", message: "Password must be 6 characters long.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
        AuthManager.shared.startAuth(phoneNumber: finalPhoneNumber) { [weak self] success, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    self.performSegue(withIdentifier: "OTPtoCheck",  sender: finalPhoneNumber)
                } else {
                    let alert = UIAlertController(title: "Authentication Error", message: error != nil ? error?.localizedDescription:"Failed to start authentication process.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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

