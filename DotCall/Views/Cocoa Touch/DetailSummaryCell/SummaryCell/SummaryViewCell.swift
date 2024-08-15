//
//  SummaryViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import UIKit
import RealmSwift

class SummaryViewCell: UITableViewCell {

    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var editTitleButton: UIButton!
    
    private let realm = try! Realm()
    internal var detailedSummary: Summary? {
        didSet {
            summaryTitle.text = detailedSummary?.summaryTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable user interaction on the label
        summaryTitle.isUserInteractionEnabled = true
        
        // Add long press gesture recognizer to the label
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        summaryTitle.addGestureRecognizer(longPressGesture)
        
        // Set up the edit button
        editTitleButton.addTarget(self, action: #selector(editTitle(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func ShareButtonPressed(_ sender: UIButton) {
        let formattedText = "Title: \(detailedSummary?.summaryTitle ?? "Try DotCall Application for Summarized Transcription of Voice Calls")\n Summary: \(detailedSummary?.summaryDetail ?? "")"
        
        let activityViewController = UIActivityViewController(activityItems: [formattedText], applicationActivities: nil)
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Show the copy menu
            UIPasteboard.general.string = summaryTitle.text
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
        UIPasteboard.general.string = summaryTitle.text
    }
    
    @objc private func editTitle(_ sender: UIButton) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        guard let viewController = self.getViewController() else {
           return
        }

        let alert = UIAlertController(title: "Edit your Title", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)

        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = self.detailedSummary?.summaryTitle

        alert.view.addSubview(textView)

        let leadConstraint = NSLayoutConstraint(item: alert.view!, attribute: .leading, relatedBy: .equal, toItem: textView, attribute: .leading, multiplier: 1.0, constant: -8.0)
        let trailConstraint = NSLayoutConstraint(item: alert.view!, attribute: .trailing, relatedBy: .equal, toItem: textView, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        let topConstraint = NSLayoutConstraint(item: alert.view!, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1.0, constant: -64.0)
        let bottomConstraint = NSLayoutConstraint(item: alert.view!, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 64.0)

        NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint])
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if textView.text.isEmpty {
                let errorAlert = UIAlertController(title: "Error", message: "Title cannot be empty.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.editTitle(sender)
                }))
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController?.present(errorAlert, animated: true, completion: nil)
                    }
                }
            } else {
                do {
                    try self.realm.write {
                        self.detailedSummary?.summaryTitle = textView.text
                    }
                    self.summaryTitle.text = textView.text
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func getViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.getViewController()
        } else {
            return nil
        }
    }
}
