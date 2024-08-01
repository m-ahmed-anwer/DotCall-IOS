//
//  TranscriptionCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit

class TranscriptionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var transcriptionText: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func share(_ sender: UIButton) {
        let formattedText = "\(transcriptionText.text ?? "Try DotCall Application for Summarized Transcription of Voice Calls")"
        
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
