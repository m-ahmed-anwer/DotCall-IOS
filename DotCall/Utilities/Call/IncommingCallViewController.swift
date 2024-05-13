//
//  IncommingCallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

import UIKit
import CallKit
import SwiftUI

class IncommingCallViewController: UIViewController, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let callUIController = CXProviderConfiguration()
        
        let callProvider = CXProvider(configuration: callUIController)
        
        callProvider.setDelegate(self, queue: nil)
        
        let callWatchman = CXCallUpdate()
        
        callWatchman.remoteHandle = CXHandle(type: .phoneNumber, value: "+94768242884")
        callWatchman.hasVideo = false
        callWatchman.localizedCallerName = "Ahmed Anwer"
        
        callProvider.reportNewIncomingCall(with: UUID(), update: callWatchman,
           completion: {error in
            if let error = error {
                print("Failed to report incomming call: \(error)")
            }else{
                print("Incomming call reported succesfully")
            }
        })
    }

}


struct IncommingCallView: UIViewControllerRepresentable{
    
    func updateUIViewController(_ uiViewController: IncommingCallViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<IncommingCallView>) -> IncommingCallViewController{
        return IncommingCallViewController()
    }
        
    func updateUIViewConreoller(_ uiViewControllers: IncommingCallViewController, context: UIViewControllerRepresentableContext<IncommingCallView>){
        
    }
}
