//
//  SummaryViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import UIKit
import RealmSwift

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var summaries: Results<SummaryUser>?

    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SummarizeCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        //loadSummaries()
        tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
//        loadSummaries()
  }
    
    
    func loadSummaries() {
        summaries = realm.objects(SummaryUser.self).sorted(byKeyPath: "recentTime", ascending: false)
        tableView.reloadData()
    }
}

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if summaries?.count != nil  {
            let summary = summaries?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SummarizeCell
            
            cell.summarizeTitleText?.text = "Topic - \(summary!.recentSummary)"
            cell.time = summary!.recentTime
            cell.callRecieverText?.text = summary!.callReciverName
            cell.selectionStyle = .gray
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSummariesCell", for: indexPath)
            cell.textLabel?.text = "No any Summarizations recorded"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }

}

extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if summaries?.count != nil  {
            if UserProfile.shared.settingsProfile.haptic == true {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            }
            performSegue(withIdentifier: "SummaryDetailsbyContact", sender: nil)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SummarybyContactViewController {
            if let indexLocale = tableView.indexPathForSelectedRow {
                destinationVC.selectedSumary = summaries?[indexLocale.row]
            }else {
                print("No row is selected")
            }
        }
    }


}

extension SummaryViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

extension SummaryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.isEmpty {
            loadSummaries()
        } else {
            summaries = realm.objects(SummaryUser.self).filter("callReciverName CONTAINS[cd] %@", searchText).sorted(byKeyPath: "recentTime", ascending: false)
        }
        tableView.reloadData()
    }
}
