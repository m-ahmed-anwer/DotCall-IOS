//
//  RecordViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-15.
//

import UIKit
import AVFoundation

class RecordViewCell: UITableViewCell, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer!
    var timer: Timer?
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var playingTime: UILabel!
    @IBOutlet weak var playPauseIcon: UIButton!
    @IBOutlet weak var recordProgress: UIProgressView!
    
    var isPlaying: Bool = false {
        didSet {
            let imageName = isPlaying ? "pauseButton" : "playButton"
            let image = UIImage(named: imageName)
            playPauseIcon.setImage(image, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isPlaying = false
        if let url = Bundle.main.url(forResource: "audioSummarize", withExtension: "wav") {
            player = try? AVAudioPlayer(contentsOf: url)
            player.delegate = self
            totalTime.text = formatTime(player.duration)
            playingTime.text = formatTime(0)
        }
        
        recordProgress.progress = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func PlayPausePressed(_ sender: UIButton) {
        if isPlaying {
            player.pause()
            stopTimer()
        } else {
            player.play()
            startTimer()
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        isPlaying.toggle()
    }
    
    @IBAction func SkipBackwardPressed(_ sender: UIButton) {
        player.currentTime = max(player.currentTime - 5, 0)
        updatePlayingTime()
        updateProgress()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @IBAction func SkipForwardPressed(_ sender: UIButton) {
        player.currentTime = min(player.currentTime + 5, player.duration)
        updatePlayingTime()
        updateProgress()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateUI() {
        updatePlayingTime()
        updateProgress()
    }
    
    private func updatePlayingTime() {
        playingTime.text = formatTime(player.currentTime)
    }
    
    private func updateProgress() {
        recordProgress.progress = Float(player.currentTime / player.duration)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        isPlaying = false
        player.currentTime = 0
        updatePlayingTime()
        updateProgress()
    }
}
