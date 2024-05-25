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
        // Remove the loading screen
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
