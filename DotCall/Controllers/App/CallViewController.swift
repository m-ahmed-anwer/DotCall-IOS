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

    internal var selectedSummary: SummaryUser?
    
    private func saveSummaryToRealm(summary:String,topic:String,trasncription:String,title:String) {
        let date = Date()
        
        do {
            try realm.write {
                let newSummary = Summary()
                newSummary.callMakerName = UserProfile.shared.generalProfile.name ?? "Ahmed"
                newSummary.callMakerUsername = UserProfile.shared.generalProfile.username ?? "123"
                newSummary.callMakerEmail = UserProfile.shared.generalProfile.email ?? "ahmed@gmail.com"
                newSummary.callReciverName = selectedSummary!.callReciverName
                newSummary.callReciverEmail = "ahmedanwer0094@gmail.com"
                newSummary.callReciverUsername = selectedSummary!.callReciverUsername
                newSummary.summaryDetail = summary
                newSummary.summaryTopic = topic
                newSummary.summaryTitle = title
                newSummary.time = date
                newSummary.transcription = trasncription
                selectedSummary!.summary.append(newSummary)
                selectedSummary!.recentTime = date
                selectedSummary!.recentSummary = title
                
            }
            print("Summary Saved")
        } catch {
            print("Error saving summary: \(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var callTimerLabel: UILabel!
    @IBOutlet weak var mutedStateImageView: UIImageView!
    @IBOutlet weak var mutedStateLabel: UILabel!
    
    
    //var call: DirectCall!
    private var isDialing: Bool?
    
    private var callTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveCallLog()
        
        
        saveSummaryToRealm(summary: "summary", topic: "topic", trasncription: "transcription",title: "title")
        
        //uploadAudio()
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    // MARK: - IBActions
    @IBAction func didTapAudioOption(_ sender: UIButton) {
        sender.isSelected.toggle()
        //self.updateLocalAudio(isEnabled: sender.isSelected)
    }
    
    
    
    @IBAction func didTapEnd() {
        self.endButton.isEnabled = false
        
        
        
        
        dismiss(animated: true, completion: nil)
        
       
        
        
        //guard let call = SendBirdCall.getCall(forCallId: self.call.callId) else { return }
        //call.end()
        //CXCallManager.shared.endCXCall(call)
    }
    
    private func saveCallLog() {

        let date = Date()
    
        let newCall = CallLog()
        newCall.callDuration = "10.10"
        newCall.callName = "\(selectedSummary!.callReciverName)"
        newCall.callUsername = "\(selectedSummary!.callReciverUsername)"
        newCall.callStatus = "Answered"
        newCall.callTime = date
        newCall.callType = "Outgoing"
    
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
    
    
    
    private func uploadAudio() {
        if let soundPath = Bundle.main.url(forResource: "audioSummarize", withExtension: "wav") {
            uploadAudioFile(url: soundPath) { result in
                switch result {
                case .success(let response):
                    // Handle the JSON response here without printing it to the console
                    if let transcription = response["transcription"] as? String,
                       let summary = response["summary"] as? String,
                       let title = response["title"] as? String,
                       let topics = response["topics"] as? [String] {
                        
                        let topicsString = topics.joined(separator: ", ")
                        
                        DispatchQueue.main.async {
                            self.saveSummaryToRealm(summary: summary, topic: title, trasncription: transcription,title: title)
                        }
                    }

                case .failure(let error):
                    // Handle the error without printing it to the console
                    print("Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Sound file not found.")
        }
    }


        



    private func uploadAudioFile(url: URL, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the API endpoint
        let apiUrl = URL(string: "http://127.0.0.1:9000/api/summarize/audio")!
        
        // Create a URL request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "--\(boundary)--\r\n"
        
        var body = Data()
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(url.lastPathComponent)\"\r\n")
        body.appendString("Content-Type: audio/wav\r\n\r\n")
        
        if let fileData = try? Data(contentsOf: url) {
            body.append(fileData)
        } else {
            print("Error: Unable to read file data.")
            return
        }
        
        body.appendString("\r\n")
        body.appendString(boundarySuffix)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120.0
        configuration.timeoutIntervalForResource = 300.0
        
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
