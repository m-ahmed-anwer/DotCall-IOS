//
//  ViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var underlineText: UILabel!
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        createButton.layer.cornerRadius = CGFloat(K.borderRadius)
        loginButton.layer.cornerRadius = CGFloat(K.borderRadius)

        
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Clear Conversation", attributes: underlineAttribute)
        underlineText.attributedText = underlineAttributedString
        
    }
    @IBAction func CreateButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    


}

