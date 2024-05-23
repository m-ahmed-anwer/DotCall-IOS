//
//  RecentCallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//
import FirebaseAuth
import UIKit
import PushKit
import SwipeCellKit
import RealmSwift

class RecentCallViewController: UITableViewController {
    
    var callLog: Results<CallLog>?
    let realm = try! Realm()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RecentCallCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
        
        loadRecentCalls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecentCalls()
    }
    
    func loadRecentCalls() {
        callLog = realm.objects(CallLog.self).sorted(byKeyPath: "callTime", ascending: false)
        tableView.reloadData()
    }
}




extension RecentCallViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLog?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if callLog?.count != nil  {
            // Configure the cell with call log details
            let call = callLog?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCallCell
            cell.time = call!.callTime
            cell.type = call!.callType
            cell.delegate = self
            cell.contactName.text = call!.callName
            cell.backgroundColor = .iosBoxBG
            return cell
        } else {
            // Configure the cell for "No recent calls recorded"
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSummariesCell", for: indexPath)
            cell.textLabel?.text = "No any recent calls recorded"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }
}


extension RecentCallViewController{
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if callLog?.count != nil  {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "voiceCall", sender: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
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


extension RecentCallViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil ) { action, indexPath in

            print("Deleted")
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteSummary(at indexPath: IndexPath) {
        if let call = callLog?[indexPath.row] {
            do{
                try realm.write{
                    realm.delete(call)
                }
            }catch{
                print("Error on deleting")
            }
        }
        tableView.reloadData()
    }
}





