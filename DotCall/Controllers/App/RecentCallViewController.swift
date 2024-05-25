//
//  RecentCallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//
import UIKit
import PushKit
import RealmSwift

class RecentCallViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var callLog: Results<CallLog>?
    private let realm = try! Realm()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecentCalls()
    }
    
    // MARK: - Actions
    
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        if UserProfile.shared.settingsProfile.haptic! {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        switch sender.selectedSegmentIndex {
        case 0:
            loadAllRecentCalls()
        case 1:
            loadMissedCalls()
        default:
            return
        }
    }
    
    @IBAction func ClearCallHistory(_ sender: UIBarButtonItem) {
        impactOccur()
        let alertController = UIAlertController()
        let deleteAction = UIAlertAction(title: "Clear Call History", style: .destructive) { _ in
            self.deleteCallHistory()
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteCallHistory() {
        do {
            try realm.write {
                realm.delete(realm.objects(CallLog.self))
            }
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } catch {
            print("Error deleting call log: \(error)")
        }
    }
}

// MARK: - Table view data source

extension RecentCallViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLog?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let callLog = callLog, !callLog.isEmpty {
            let call = callLog[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCallCell
            cell.time = call.callTime
            cell.type = call.callType
            cell.contactName.text = call.callName
            cell.backgroundColor = .iosBoxBG
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSummariesCell", for: indexPath)
            cell.textLabel?.text = "No any recent calls recorded"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCall(at: indexPath)
        }
    }

}

// MARK: - Table view delegate

extension RecentCallViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let callLogCount = callLog?.count, callLogCount > indexPath.row {
            performSegue(withIdentifier: "voiceCall", sender: nil)
        }
    }
}


// MARK: - Private Methods

private extension RecentCallViewController {
    private func setupTableView() {
        tableView.register(UINib(nibName: "RecentCallCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
        tableView.tableFooterView = UIView() // Hide empty cells
    }
    
    private func loadRecentCalls() {
        callLog = realm.objects(CallLog.self).sorted(byKeyPath: "callTime", ascending: false)
        tableView.reloadData()
    }
    
    private func loadAllRecentCalls() {
        callLog = realm.objects(CallLog.self).sorted(byKeyPath: "callTime", ascending: false)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func loadMissedCalls() {
        callLog = realm.objects(CallLog.self).filter("callType == 'Missed'").sorted(byKeyPath: "callTime", ascending: false)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func deleteCall(at indexPath: IndexPath) {
        guard let callLog = callLog?[indexPath.row] else { return }
        do {
            try realm.write {
                realm.delete(callLog)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Error deleting call log: \(error)")
        }
    }
    private func impactOccur() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
