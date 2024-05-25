//
//  SignupConfirmationController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-23.
//

import UIKit

class SignupConfirmationController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        // Disable swipe back gesture and customize back button appearance
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        
        // Set corner radius for complete button
        completeButton.layer.cornerRadius = CGFloat(K.borderRadius)
    }
}
