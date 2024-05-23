//
//  SummarybyContactViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-18.
//

import UIKit
import RealmSwift
import SwipeCellKit

class SummarybyContactViewController: UITableViewController {
    
    var summaries: Results<Summary>?
    let realm = try! Realm()
    
    var phoneByContact:String?{
        didSet{
            loadSummary(phone: phoneByContact!)
        }
    }
    
    var selectedSumary: SummaryUser? {
        didSet {
            if let name = selectedSumary?.callReciverName {
                navigationItem.title = name
            }
            loadSummary(phone:selectedSumary!.callReciverPhoneNum)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backButton]
        navigationController?.navigationBar.tintColor = UIColor.backButton
        
        searchController.searchBar.placeholder = "Search by Summarizations"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        tableView.register(UINib(nibName: "SummaryByContactViewCell", bundle: nil), forCellReuseIdentifier: "SummaryByContact")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
    }
   
    
    func loadSummary(phone:String) {
        summaries = realm.objects(Summary.self).filter("callReciverPhoneNum == %@", phone).sorted(byKeyPath: "time", ascending: false)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension SummarybyContactViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if summaries?.count != nil  {
            let summary = summaries?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryByContact", for: indexPath) as! SummaryByContactViewCell
            cell.delegate = self
            cell.time = summary!.time
            cell.titleText.text = summary?.summaryTopic
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSummariesCell", for: indexPath)
            cell.textLabel?.text = "No any conversations recorded"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }

}


extension SummarybyContactViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if summaries?.count != nil  {
            if UserProfile.shared.settingsProfile.haptic == true {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            }
            
            performSegue(withIdentifier: "DetailtoSummaryCheck", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailSummaryViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.detailedSumary = summaries?[indexPath.row]
            } else {
                print("No row is selected")
            }
        }
    }
}

extension SummarybyContactViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.isEmpty {
            if let selectedSummary = selectedSumary {
                loadSummary(phone: selectedSummary.callReciverPhoneNum)
            }
        } else {
            summaries = realm.objects(Summary.self).filter("callReciverPhoneNum == %@ AND summaryTopic CONTAINS[cd] %@", selectedSumary!.callReciverPhoneNum, searchText).sorted(byKeyPath: "time", ascending: false)
        }
        tableView.reloadData()
    }
}



extension SummarybyContactViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteSummary(at: indexPath)
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
        if let summaryToDelete = summaries?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(summaryToDelete)
                }
            }catch{
                print("Error on deleting")
            }
        }
        tableView.reloadData()
    }
}
