//
//  CallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

import UIKit
import AVKit
import CallKit
import MediaPlayer
import AVFAudio
import RealmSwift
import WebKit


class CallViewController: UIViewController {
    
    private let realm = try! Realm()

    internal var selectedSummary: SummaryUser? {
        didSet {
            saveSummaryToRealm(selectedSummary!)
        }
    }
    
    private func saveSummaryToRealm(_ summaryUser: SummaryUser) {
        let date = Date()
        
        do {
            try realm.write {
                let newSummary = Summary()
                newSummary.callMakerName = UserProfile.shared.generalProfile.name ?? "Ahmed"
                newSummary.callMakerPhoneNum = UserProfile.shared.generalProfile.phoneNumber ?? "123"
                newSummary.callMakerEmail = UserProfile.shared.generalProfile.email ?? "ahmed@gmail.com"
                newSummary.callReciverName = summaryUser.callReciverName
                newSummary.callReciverEmail = "ahmedanwer0094@gmail.com"
                newSummary.callReciverPhoneNum = summaryUser.callReciverPhoneNum
                newSummary.summaryDetail = "The detail of summary is not a big detail, it's kind of ok or not a problem so far"
                newSummary.summaryTopic = "The topic is this, nothing more or less than good or bad"
                newSummary.time = date
                newSummary.transcription = "This is the transcription, it's not more like nothing brother"
                summaryUser.summary.append(newSummary)
                summaryUser.recentTime = date
            }
            print("Savedddd summary")
        } catch {
            print("Error saving summary: \(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
//          {
//    didSet {
//            let profileURL = self.call.remoteUser?.profileURL
//            self.profileImageView = UIImageView(image: .prof)
//        }
//    }
    
    @IBOutlet weak var nameLabel: UILabel!
//    {
//        didSet {
//            //let nickname = self.call.remoteUser?.nickname
//            self.nameLabel.text =  "Ahmed Anwer" //nickname?.isEmptyOrWhitespace == true ? self.call.remoteUser?.userId : nickname
//        }
//    }

    @IBOutlet weak var speakerButton: UIButton!
    
    @IBOutlet weak var muteAudioButton: UIButton! {
        didSet {
            //self.muteAudioButton.isSelected = !self.call.isLocalAudioEnabled
        }
    }
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var callTimerLabel: UILabel!
    
    // Notify muted state
    @IBOutlet weak var mutedStateImageView: UIImageView!
    
    @IBOutlet weak var mutedStateLabel: UILabel!
//    {
//        didSet {
//            guard let remoteUser = self.call.remoteUser else { return }
//            let name = remoteUser.nickname?.isEmptyOrWhitespace == true ? remoteUser.userId : remoteUser.nickname!
//            
//            self.mutedStateLabel.text = CallStatus.muted(user: name).message
//        }
//    }
    
    
    //var call: DirectCall!
    private var isDialing: Bool?
    
    private var callTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
       

        //self.call.delegate = self
        
//        self.setupAudioOutputButton()
//        self.updateRemoteAudio(isEnabled: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        guard self.isDialing == true else { return }
//        CXCallManager.shared.startCXCall(self.call) { [weak self] isSucceed in
//            guard let self = self else { return }
//            if !isSucceed {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        
    }
    
    // MARK: - IBActions
    @IBAction func didTapAudioOption(_ sender: UIButton) {
        sender.isSelected.toggle()
        //self.updateLocalAudio(isEnabled: sender.isSelected)
    }
    
    
    
    @IBAction func didTapEnd() {
        self.endButton.isEnabled = false
        
        if let selectedSummary = selectedSummary{
            saveCallLog()
        }
        
        
        dismiss(animated: true, completion: nil)
        
       
        
        
        //guard let call = SendBirdCall.getCall(forCallId: self.call.callId) else { return }
        //call.end()
        //CXCallManager.shared.endCXCall(call)
    }
    
    private func saveCallLog() {

        let date = Date()
    
        let newCall = CallLog()
        newCall.callDuration = "00.10"
        newCall.callName = "\(selectedSummary!.callReciverName)"
        newCall.callPhoneNum = "\(selectedSummary!.callReciverPhoneNum)"
        newCall.callStatus = "Answered"
        newCall.callTime = date
        newCall.callType = "Incoming"
    
        do {
            try realm.write {
                realm.add(newCall)
            }
        } catch {
            print("Error saving summary: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Basic UI
    private func setupEndedCallUI() {
        self.callTimer?.invalidate()    // Main thread
        self.callTimer = nil
        //self.callTimerLabel.text = CallStatus.ended(result: call.endResult.rawValue).message
        
        self.endButton.isHidden = true
        self.speakerButton.isHidden = true
        self.muteAudioButton.isHidden = true
        
        self.mutedStateImageView.isHidden = true
        self.mutedStateLabel.isHidden = true
    }
}

    

//// MARK: - SendBirdCall: Audio Features
//extension CallViewController {
//    func updateLocalAudio(isEnabled: Bool) {
//        self.muteAudioButton.setBackgroundImage(.audio(isOn: isEnabled), for: .normal)
//        if isEnabled {
//            call?.muteMicrophone()
//        } else {
//            call?.unmuteMicrophone()
//        }
//    }
//    
//    func updateRemoteAudio(isEnabled: Bool) {
//        self.mutedStateImageView.isHidden = isEnabled
//        self.mutedStateLabel.isHidden = isEnabled
//    }
//}
//
//// MARK: - SendBirdCall: Audio Output
//extension CallViewController {
//    func setupAudioOutputButton() {
//        let width = self.speakerButton.frame.width
//        let height = self.speakerButton.frame.height
//        let frame = CGRect(x: 0, y: 0, width: width, height: height)
//    
//        let routePickerView = SendBirdCall.routePickerView(frame: frame)
//        self.customize(routePickerView)
//        self.speakerButton.addSubview(routePickerView)
//    }
//    
//    func customize(_ routePickerView: UIView) {
//        if #available(iOS 11.0, *) {
//            guard let routePickerView = routePickerView as? AVRoutePickerView else { return }
//            routePickerView.activeTintColor = .clear
//            routePickerView.tintColor = .clear
//        } else {
//            guard let volumeView = routePickerView as? MPVolumeView else { return }
//            
//            volumeView.showsVolumeSlider = false
//            volumeView.setRouteButtonImage(nil, for: .normal)
//            volumeView.routeButtonRect(forBounds: volumeView.frame)
//        }
//    }
//}
//
//// MARK: - SendBirdCall: DirectCall duration
//extension CallViewController {
//    func activeTimer() {
//        self.callTimerLabel.text = "00:00"
//        
//        // Main thread
//        self.callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//            guard let self = self else { return }
//
//            // update UI
//            self.callTimerLabel.text = self.call.duration.durationText()
//
//            // Timer Invalidate
//            if self.call.endedAt != 0, timer.isValid {
//                timer.invalidate()
//                self.callTimer = nil
//            }
//        }
//    }
//}
//
//// MARK: - SendBirdCall: DirectCallDelegate
//// Delegate methods are executed on Main thread
//
//extension CallViewController: DirectCallDelegate {
//    // MARK: Required Methods
//    func didConnect(_ call: DirectCall) {
//        self.activeTimer()      // call.duration
//        self.updateRemoteAudio(isEnabled: call.isRemoteAudioEnabled)
//      
//        CXCallManager.shared.connectedCall(call)
//    }
//    
//    func didEnd(_ call: DirectCall) {
//        self.setupEndedCallUI()
//        
//        DispatchQueue.main.async {
//            guard let callLog = call.callLog else { return }
//            UserDefaults.standard.callHistories.insert(CallHistory(callLog: callLog), at: 0)
//            
//            CallHistoryViewController.main?.updateCallHistories()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        guard let enderId = call.endedBy?.userId, let myId = SendBirdCall.currentUser?.userId, enderId != myId else { return }
//        guard let call = SendBirdCall.getCall(forCallId: self.call.callId) else { return }
//        CXCallManager.shared.endCXCall(call)
//    }
//    
//    // MARK: Optional Methods
//    func didEstablish(_ call: DirectCall) {
//        self.callTimerLabel.text = CallStatus.connecting.message
//    }
//    
//    func didRemoteAudioSettingsChange(_ call: DirectCall) {
//        self.updateRemoteAudio(isEnabled: call.isRemoteAudioEnabled)
//    }
//    
//    func didAudioDeviceChange(_ call: DirectCall, session: AVAudioSession, previousRoute: AVAudioSessionRouteDescription, reason: AVAudioSession.RouteChangeReason) {
//        guard !call.isEnded else { return }
//        guard let output = session.currentRoute.outputs.first else { return }
//        
//        self.speakerButton.setBackgroundImage(.audio(output: output.portType),
//                                                 for: .normal)
//        print("[QuickStart] Audio Route has been changed to \(output.portName)")
//    }
//}
