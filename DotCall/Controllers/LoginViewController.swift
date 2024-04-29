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

        // Continue with login process
        if countryCode == "" {
            print("Phone Number: +94\(phoneNumber)")
            print("Password: \(password)")
        } else {
            print("Phone Number: \(countryCode)\(phoneNumber)")
            print("Password: \(password)")
        }
        
        performSegue(withIdentifier: "OTPtoCheck", sender: nil)
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
