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
import TwilioVoice

let accessToken = "PASTE_YOUR_ACCESS_TOKEN_HERE"
let twimlParamTo = "to"

let kCachedDeviceToken = "CachedDeviceToken"
class CallViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startDemo(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            let callManager = CallManager()
            let id = UUID()
            
            
        })
    }
    

}
