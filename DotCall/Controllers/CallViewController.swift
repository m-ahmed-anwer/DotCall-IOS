//
//  CallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

import UIKit
import CallKit

class CallViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startDemo(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            let callManager = CallManager()
            let id = UUID()
            callManager.reportIncommingCall(id: id, handle: "Ahmed Anwer")
            
        })
    }
    

}
