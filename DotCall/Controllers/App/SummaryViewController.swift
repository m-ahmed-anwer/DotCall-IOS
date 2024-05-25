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
    private let realm = try! Realm()
    private var summaries: Results<SummaryUser>?
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        setupTabBarController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSummaries()
    }
    
    @IBAction func EditButtonPressed(_ sender: UIBarButtonItem) {
        // Handle edit button action
    }
    
    private func loadSummaries() {
        summaries = realm.objects(SummaryUser.self).sorted(byKeyPath: "recentTime", ascending: false)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if summaries!.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSummariesCell", for: indexPath)
            cell.textLabel?.text = "No any Summarizations recorded"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        } else {
            let summary = summaries?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SummarizeCell
            
            cell.summarizeTitleText?.text = "Topic - \(summary!.recentSummary)"
            cell.time = summary!.recentTime
            cell.callRecieverText?.text = summary!.callReciverName
            cell.selectionStyle = .gray
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate

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

// MARK: - UITabBarControllerDelegate

extension SummaryViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

// MARK: - UISearchResultsUpdating

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

// MARK: - Private Methods

private extension SummaryViewController {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SummarizeCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoSummariesCell")
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
    }
    
    private func setupTabBarController() {
        tabBarController?.delegate = self
    }
}
