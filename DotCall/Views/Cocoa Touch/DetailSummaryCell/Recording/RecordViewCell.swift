//
//  RecordViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-15.
//

import UIKit

class RecordViewCell: UITableViewCell {

    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var playingTime: UILabel!
    
    @IBOutlet weak var playPasueIcon: UIButton!
    @IBOutlet weak var recordProgress: UIProgressView!
    
    var isPlaying: Bool = false {
        didSet {
            let imageName = isPlaying ? "pauseButton" : "playButton"
            let image = UIImage(named: imageName)
            playPasueIcon.setImage(image, for: .normal)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isPlaying = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func PlayPausePressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        isPlaying.toggle()
    }
    
    @IBAction func SkipBackwardPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @IBAction func SkipForwardPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    
}
