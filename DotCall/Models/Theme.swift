//
//  Theme.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import Foundation
import UIKit

enum Theme {
    case light
    case dark

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }

    // Add more appearance properties as needed
}
