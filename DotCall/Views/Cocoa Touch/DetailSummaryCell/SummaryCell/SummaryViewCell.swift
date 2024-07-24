//
//  SummaryViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import UIKit

class SummaryViewCell: UITableViewCell {

    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var summaryText: UILabel!
    @IBOutlet weak var summaryTopic: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func CopyButtonPressed(_ sender: UIButton) {
       let formattedText = "\(summaryTitle.text ?? "Try DotCall Application for Summarized Transcription of Voice Calls")\n\(summaryText.text ?? "")"
       
       // Copy the formatted text to the pasteboard
       UIPasteboard.general.string = formattedText
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
       let alert = UIAlertController(title: "Copied", message: "Summary has been copied to clipboard", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first, let viewController = window.rootViewController {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ShareButtonPressed(_ sender: UIButton) {
        
        let formattedText = "\(summaryTitle.text ?? "Try DotCall Application for Summarized Transcription of Voice Calls")\n\(summaryText.text ?? "")"
        
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


    
}
