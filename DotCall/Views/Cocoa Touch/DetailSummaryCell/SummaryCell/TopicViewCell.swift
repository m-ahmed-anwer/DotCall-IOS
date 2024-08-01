//
//  TopicViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-08-01.
//

import UIKit

class TopicViewCell: UITableViewCell {

    @IBOutlet weak var summaryTopic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable user interaction on the label
        summaryTopic.isUserInteractionEnabled = true
        
        // Add long press gesture recognizer to the label
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        summaryTopic.addGestureRecognizer(longPressGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Handle long press gesture
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            becomeFirstResponder()
            
            let menuController = UIMenuController.shared
            let copyMenuItem = UIMenuItem(title: "Copy", action: #selector(copyText))
            menuController.menuItems = [copyMenuItem]
            
            if let label = gesture.view as? UILabel {
                menuController.setTargetRect(label.bounds, in: label)
                menuController.setMenuVisible(true, animated: true)
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText) {
            return true
        }
        return false
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = summaryTopic.text
    }
}
