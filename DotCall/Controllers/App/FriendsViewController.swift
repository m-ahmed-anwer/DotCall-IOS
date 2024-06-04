//
//  ContactsViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import Contacts
import ContactsUI
import UIKit
import Firebase

class FriendsViewController: UITableViewController {
    
    // MARK: - Properties
    private var friendsList: [[String: Any]] = []
    private var toAcceptfriendsList: [[String: Any]] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Actions
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        impactOccur()
        tableView.reloadData()
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        updateDetails()
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchRegisteredPhoneNumbers()
    }
    

    // MARK: - Actions
    @IBAction func GroupCallButtonPressed(_ sender: UIBarButtonItem) {
        impactOccur()
        
    }
    
    @IBAction func plusIconPressed(_ sender: UIBarButtonItem) {
        impactOccur()
        performSegue(withIdentifier: "addFriend", sender: nil)
    }
    

}

// MARK: - UISearchResultsUpdating
extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }

        if searchText.isEmpty {
           
        } else {
            
        }
    }
}


// MARK: - UITableViewDataSource

extension FriendsViewController : AcceptFriendCellDelegate{
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return friendsList.isEmpty ? 1 : friendsList.count
        case 1: return toAcceptfriendsList.isEmpty ? 1 : toAcceptfriendsList.count
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if friendsList.isEmpty{
                return 200
            } else {
                return UITableView.automaticDimension
            }
        case 1:
            if toAcceptfriendsList.isEmpty{
                return 200
            } else {
                return UITableView.automaticDimension
            }
        default: return UITableView.automaticDimension
            
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if friendsList.isEmpty {
                let cell = CenteredTextTableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = .gray
                cell.textLabel?.text = "You have no friends. Add friends..."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseContact", for: indexPath) as! FriendCell
                cell.contactName.text = friendsList[indexPath.row]["name"] as? String
                return cell
            }
        case 1:
            if toAcceptfriendsList.isEmpty {
                let cell = CenteredTextTableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = .gray
                cell.textLabel?.text = "You have no any friends to accept..."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptFriend", for: indexPath) as! AcceptFriendsTableViewCell
                cell.name.text  = toAcceptfriendsList[indexPath.row]["name"] as? String
                cell.username.text = toAcceptfriendsList[indexPath.row]["username"] as? String
                cell.email = (toAcceptfriendsList[indexPath.row]["email"] as? String)!
                cell.tag = indexPath.row // Set the tag to the row index
                cell.delegate = self
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    func acceptButtonPressed(atIndex index: Int) {
        DispatchQueue.main.async {
            self.toAcceptfriendsList.remove(at: index)
            self.updateDetails()
            self.tableView.reloadData()
        }
    }

    

}

// MARK: - UITableViewDelegate

extension FriendsViewController {

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        impactOccur()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - Private Methods

private extension FriendsViewController{
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionIndexColor = UIColor.themeText
        tableView.register(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
        tableView.register(UINib(nibName: "AcceptFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AcceptFriend")
        
        
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    

    private func findFriends (completion: @escaping ([[String: Any]]?, Bool, Error?) -> Void) {
        // Prepare the URL
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion(nil, false, NSError(domain: "User email not found", code: 0, userInfo: nil))
            return
        }
        let urlString = "https://dot-call-a7ff3d8633ee.herokuapp.com/friends/getFriends/\(currentUserEmail)"
        guard let url = URL(string: urlString) else {
            completion(nil, false, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, false, error)
                return
            }

            do {
                if let data = data,
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let matchingUsers = json["friends"] as? [[String: Any]] {

                    var usersArray: [[String: Any]] = []
                    for user in matchingUsers {
                        guard let username = user["username"] as? String,
                              let email = user["email"] as? String,
                              let name = user["name"] as? String else {
                            continue
                        }
                        let userDict: [String: Any] = ["username": username, "email": email, "name": name]
                        usersArray.append(userDict)
                    }

                    if matchingUsers.isEmpty {
                        completion(nil, false, nil)
                    } else {
                        completion(usersArray, true, nil)
                    }
                } else {
                    completion(nil, false, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                }
            } catch {
                completion(nil, false, error)
            }
        }

        task.resume()
    }
    
    private func friendsToAccept(completion: @escaping ([[String: Any]]?, Bool, Error?) -> Void) {
        // Prepare the URL
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion(nil, false, NSError(domain: "User email not found", code: 0, userInfo: nil))
            return
        }
        let urlString = "https://dot-call-a7ff3d8633ee.herokuapp.com/friends/getFriendsToAccept/\(currentUserEmail)"
        guard let url = URL(string: urlString) else {
            completion(nil, false, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, false, error)
                return
            }

            do {
                if let data = data,
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let matchingUsers = json["friendsToAccept"] as? [[String: Any]] {

                    var usersArray: [[String: Any]] = []
                    for user in matchingUsers {
                        guard let username = user["username"] as? String,
                              let email = user["email"] as? String,
                              let name = user["name"] as? String else {
                            continue
                        }
                        let userDict: [String: Any] = ["username": username, "email": email, "name": name]
                        usersArray.append(userDict)
                    }

                    if matchingUsers.isEmpty {
                        completion(nil, false, nil)
                    } else {
                        completion(usersArray, true, nil)
                    }
                } else {
                    completion(nil, false, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                }
            } catch {
                completion(nil, false, error)
            }
        }

        task.resume()
    }

    
    private func impactOccur() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    private func updateDetails(){
        friendsToAccept() { (users, success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if success {
                if let users = users {
                    self.toAcceptfriendsList = users
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        findFriends() { (users, success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if success {
                if let users = users {
                    self.friendsList = users
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
}
