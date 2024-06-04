//
//  LoadingManager.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-01.
//

import UIKit

class LoadingManager {
    // MARK: - Properties
    static let shared = LoadingManager()
    private var loadingView: UIView?

    // MARK: - Private Initialization
    private init() {}

    // MARK: - Public Methods
    func showLoadingScreen() {
        // Create a loading screen if it doesn't exist
        if loadingView == nil {
            loadingView = UIView(frame: UIScreen.main.bounds)
            loadingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = loadingView!.center
            loadingView?.addSubview(spinner)
            spinner.startAnimating()

            // Add the loading screen to the key window
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(loadingView!)
            }
        }
    }

    func hideLoadingScreen() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    func showValidatingLoadingScreen() {
        if loadingView == nil {
            loadingView = UIView(frame: UIScreen.main.bounds)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            label.text = "Validating..."
            label.textAlignment = .center
            label.center = loadingView!.center
            
            if #available(iOS 13.0, *) {
                let backgroundColor = UIColor { traitCollection in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        label.textColor = UIColor.white
                        return UIColor.black.withAlphaComponent(1)
                    default:
                        label.textColor = UIColor.black
                        return UIColor.white.withAlphaComponent(1)
                    }
                }
                loadingView?.backgroundColor = backgroundColor
            } else {
                label.textColor = UIColor.white
                loadingView?.backgroundColor = UIColor.black.withAlphaComponent(1)
            }
            
            // Add a label for the "Validating" text
            
            loadingView?.addSubview(label)
            
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = CGPoint(x: loadingView!.bounds.midX, y: loadingView!.bounds.midY - 25)
            loadingView?.addSubview(spinner)
            spinner.startAnimating()

            // Add the loading screen to the key window
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(loadingView!)
            }
        }
    }
}
