//
//  SignupViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var otpButton: UIButton!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var greetingText: UILabel!
    
    var countryCode = ""
    
    var name: String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        greetingText.text = "Hello \(name)!"
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberField.delegate = self
        
        let countryMenu = UIMenu(title: "Country Code", children: createCountryMenuItems())
        countryButton.menu = countryMenu
        
        
        navigationController?.navigationBar.barStyle = .black
        
        otpButton.layer.cornerRadius = CGFloat(K.borderRadius)
        
        phoneNumberField.addBottomBorder(withColor: UIColor.inputBelow, thickness: 1.0)
        
        
    }
    
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        
        guard let phoneNumber = phoneNumberField.text, !phoneNumber.isEmpty, let _ = Int(phoneNumber)  else {
                alert(title: "Missing Information", message: "Please enter your phone number.")
                return
            }
        var finalPhoneNumber: String
        
        if countryCode == "" {
            finalPhoneNumber = "+94\(phoneNumber)"
            print("Phone Number: +94\(phoneNumber)")
        } else {
            finalPhoneNumber = "\(countryCode)\(phoneNumber)"
            print("Phone Number: \(countryCode)\(phoneNumber)")
        }
        
        LoadingManager.shared.showLoadingScreen()
        AuthManager.shared.startAuth(phoneNumber: finalPhoneNumber) { [weak self] success, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    userPhoneNumber = finalPhoneNumber
                    self.performSegue(withIdentifier: "SignUpToCheck",  sender: finalPhoneNumber)
                } else {
                    self.alert(title: "Authentication Error", message: error != nil ? error!.localizedDescription:"Failed to start authentication process.")
                    
                   
                }
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToCheck" {
            if let destinationVC = segue.destination as? SignUpOTPController {
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

extension SignupViewController: UITextFieldDelegate {
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

extension SignupViewController{
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
