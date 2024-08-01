//
//  SummaryDetailViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-08-01.
//

import UIKit
import RealmSwift

class SummaryDetailViewCell: UITableViewCell {
    
    @IBOutlet weak var editSummaryButton: UIButton!
    @IBOutlet weak var summaryText: UILabel!
    
    private let realm = try! Realm()
    internal var detailedSummary: Summary? {
        didSet {
            summaryText.text = detailedSummary?.summaryDetail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable user interaction on the label
        summaryText.isUserInteractionEnabled = true
        
        // Add long press gesture recognizer to the label
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        summaryText.addGestureRecognizer(longPressGesture)
        
        // Set up the edit button
        editSummaryButton.addTarget(self, action: #selector(editSummary(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Show the copy menu
            UIPasteboard.general.string = summaryText.text
            let menuController = UIMenuController.shared
            let copyMenuItem = UIMenuItem(title: "Copy", action: #selector(copyText))
            menuController.menuItems = [copyMenuItem]
            
            if let label = gesture.view as? UILabel {
                menuController.setTargetRect(label.bounds, in: label)
                menuController.setMenuVisible(true, animated: true)
            }
        }
    }
    
    @objc private func copyText() {
        UIPasteboard.general.string = summaryText.text
    }
    
    @objc private func editSummary(_ sender: UIButton){
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        guard let viewController = self.getViewController() else {
           return
        }

        let alert = UIAlertController(title: "Edit your Summary", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)

        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = self.detailedSummary?.summaryDetail

        alert.view.addSubview(textView)

        let leadConstraint = NSLayoutConstraint(item: alert.view!, attribute: .leading, relatedBy: .equal, toItem: textView, attribute: .leading, multiplier: 1.0, constant: -8.0)
        let trailConstraint = NSLayoutConstraint(item: alert.view!, attribute: .trailing, relatedBy: .equal, toItem: textView, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        let topConstraint = NSLayoutConstraint(item: alert.view!, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1.0, constant: -64.0)
        let bottomConstraint = NSLayoutConstraint(item: alert.view!, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 64.0)

        NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint])
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if textView.text.isEmpty {
                let errorAlert = UIAlertController(title: "Error", message: "Summary cannot be empty.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.editSummary(sender)
                }))
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController?.present(errorAlert, animated: true, completion: nil)
                    }
                }
            } else {
                do {
                    try self.realm.write {
                        self.detailedSummary?.summaryDetail = textView.text
                    }
                    self.summaryText.text = textView.text
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
}
