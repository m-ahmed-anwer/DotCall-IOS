//
//  LoadingManager.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-01.
//

import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    
    private var loadingView: UIView?
    
    private init() {}
    
    func showLoadingScreen() {
        if loadingView == nil {
            loadingView = UIView(frame: UIScreen.main.bounds)
            loadingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = loadingView!.center
            loadingView?.addSubview(spinner)
            spinner.startAnimating()
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(loadingView!)
            }
        }
    }
    
    func hideLoadingScreen() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}

