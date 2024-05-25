//
//  SummarybyContactViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-18.
//

import UIKit
import RealmSwift

class SummarybyContactViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var summaries: Results<Summary>?
    private let realm = try! Realm()
    
    internal var phoneByContact: String? {
        didSet {
            loadSummary(phone: phoneByContact!)
        }
    }
    
    internal var selectedSumary: SummaryUser? {
        didSet {
            if let name = selectedSumary?.callReciverName {
                navigationItem.title = name
            }
            loadSummary(phone: selectedSumary!.callReciverPhoneNum)
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backButton]
        navigationController?.navigationBar.tintColor = UIColor.backButton
        setupSearchController()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Table View Data Source

extension SummarybyContactViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !(summaries!.isEmpty) {
            let summary = summaries?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryByContact", for: indexPath) as! SummaryByContactViewCell
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
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Delete Summary", message: "Once you delete this summary, it cannot be retrieved. Are you sure you want to delete it?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.deleteSummary(at: indexPath)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Table View Delegate

extension SummarybyContactViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if summaries?.count != nil {
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
                destinationVC.detailedSummary = summaries?[indexPath.row]
            } else {
                print("No row is selected")
            }
        }
    }
}

// MARK: - Search Results Updating

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

// MARK: - Private Methods

private extension SummarybyContactViewController {
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search by Summarizations"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SummaryByContactViewCell", bundle: nil), forCellReuseIdentifier: "SummaryByContact")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
    }
    
    private func loadSummary(phone: String) {
        summaries = realm.objects(Summary.self).filter("callReciverPhoneNum == %@", phone).sorted(byKeyPath: "time", ascending: false)
        tableView.reloadData()
    }
    
    private func deleteSummary(at indexPath: IndexPath) {
        tableView.beginUpdates()
        if let summaryToDelete = summaries?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(summaryToDelete)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting summary: \(error)")
            }
        }
        tableView.endUpdates()
    }
}
