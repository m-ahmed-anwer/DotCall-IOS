//
//  CallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

import UIKit
import AVFoundation
import PushKit
import CallKit
import AVFAudio


class CallViewController: UIViewController {
    
    var contactName: String?
    var contactPhone: String?
    var contactImage: UIImage?
    

    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var callingTime: UILabel!
    
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
 
    
    var isMicMuted = false
    var isSpeakerOn = false
    var timer: Timer?
    var durationInSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        callerName.text = contactName
        callerImage.image = contactImage
        
        callerImage.layer.cornerRadius = callerImage.bounds.width / 2
        callerImage.clipsToBounds = true
        
        
        callingTime.text = "calling \(contactPhone ?? "Ahmed")..."
        //startTimer()
    
    
//        
//        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "DotCall"))
//        provider.setDelegate(self, queue: nil)
//        let controller = CXCallController()
//        
//        
//        ///just addeded for temoporary check
//        ///delete it after the correceted
//        
//        
//        if let contactName = contactName{
//            let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: contactName )))
//            controller.request(transaction, completion: { error in })
//        }
//     
//        
    

        
    }
    
    deinit {
        timer?.invalidate()
    }

    @IBAction func EndButtonPressed(_ sender: UIButton) {
        timer?.invalidate()
        
        // Create a CXCallController and request to end the call
        let controller = CXCallController()
        let transaction = CXTransaction(action: CXEndCallAction(call: UUID()))
        controller.request(transaction, completion: { error in
            if let error = error {
                print("Error ending call: \(error.localizedDescription)")
            } else {
                // Pop the view controller when the call is successfully ended
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }

    
    
    @IBAction func MuteButtonPressed(_ sender: UIButton) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: .mixWithOthers)
            let currentRoute = session.currentRoute
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    try session.overrideOutputAudioPort(.none)
                } else {
                    try session.overrideOutputAudioPort(.speaker)
                }
            }
            let currentRouteInputs = session.currentRoute.inputs
            for description in currentRouteInputs {
                if description.portType == AVAudioSession.Port.builtInMic {
                    if isMicMuted {
                        try session.setPreferredInput(description)
                    } else {
                        try session.setPreferredInput(nil)
                    }
                }
            }
            try session.setActive(true)

            // Toggle mic mute state
            isMicMuted.toggle()
            print("Microphone muted: \(isMicMuted)")

            // Update button image and title
            let imageName = isMicMuted ? "micSlash" : "mic"
            sender.setImage(UIImage(named: imageName), for: .normal)

        } catch {
            print("Error toggling microphone state: \(error.localizedDescription)")
        }
    }

    @IBAction func SpeakerButtonPressed(_ sender: UIButton) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            
            if isSpeakerOn {
                try session.overrideOutputAudioPort(.none)
            } else {
                try session.overrideOutputAudioPort(.speaker)
            }
            
            isSpeakerOn.toggle()
            print("Speaker mode: \(isSpeakerOn ? "On" : "Off")")
            
            // Update button image and title
            let imageName = isSpeakerOn ? "speakerWave" : "speakerNoWave"
            sender.setImage(UIImage(named: imageName), for: .normal)
            
        } catch {
            print("Error toggling speakerphone mode: \(error.localizedDescription)")
        }
    }

    

    func startTimer() {
        // Invalidate any existing timer
        timer?.invalidate()
        
        // Start a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Update the duration label
            self.durationInSeconds += 1
            let hours = self.durationInSeconds / 3600
            let minutes = (self.durationInSeconds % 3600) / 60
            let seconds = self.durationInSeconds % 60
            self.callingTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

extension UIButton {

    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}

extension CallViewController: CXProviderDelegate {
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Handle answer action
        action.fulfill()
        startTimer()
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // Handle start call action
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Handle end call action
        action.fulfill()
        navigationController?.popViewController(animated: true)
    }

    func providerDidReset(_ provider: CXProvider) {
        // Reset any call-related state
    }
}
