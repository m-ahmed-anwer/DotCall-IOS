//
//  ViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var underlineText: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupUnderlineText()
    }
   
    
    // MARK: - Button Actions
    
    @IBAction func CreateButtonPressed(_ sender: UIButton) {
        impactFeedback()
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        impactFeedback()
    }
    
    // MARK: - Helper Methods
    
    private func impactFeedback() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

// MARK: - Private Methods

private extension ViewController{
    
    
    private  func setupButtons() {
        createButton.layer.cornerRadius = CGFloat(K.borderRadius)
        loginButton.layer.cornerRadius = CGFloat(K.borderRadius)
    }
    
    private func setupUnderlineText() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Clear Conversation", attributes: underlineAttribute)
        underlineText.attributedText = underlineAttributedString
    }
}
