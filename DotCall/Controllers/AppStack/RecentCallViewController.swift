//
//  RecentCallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//
import FirebaseAuth
import UIKit
import PushKit

class RecentCallViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UINib(nibName: "RecentCallCell", bundle: nil), forCellReuseIdentifier: "RecentCell")

        // Do any additional setup after loading the view.
    }
}




extension RecentCallViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //recentCall.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier:  "RecentCell", for: indexPath) as! RecentCallCell
        
        cell.backgroundColor = .iosBoxBG
        
        return cell
    }



}

extension RecentCallViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "voiceCall", sender: nil)
        }
    }


}

extension RecentCallViewController: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // Handle the incoming call notification
        // Present the CallViewController
        UIStoryboard(name: "CallStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CallViewControllerIdentifier") is CallViewController
        
        // Call the completion handler
        completion()
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        // Handle token invalidation
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // Handle token update
    }
}

