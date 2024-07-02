//
//  AudioControllerDelegate.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-07-02.
//

import Foundation
import Sinch

class AudioContollerDelegate: NSObject, SINAudioControllerDelegate {
    
    var muted: Bool!
    var speaker: Bool!//not needed
    
    func audioControllerMuted(_ audioController: SINAudioController!) {
        self.muted = true
    }
    
    func audioControllerUnmuted(_ audioController: SINAudioController) {
        self.muted = false
    }
    
    //not needed
    func audioControllerSpeakerEnabled(_ audioController: SINAudioController!) {
        self.speaker = true
    }
    
    func audioControllerSpeakerDisabled(_ audioController: SINAudioController!) {
        self.speaker = false
    }
    
}
