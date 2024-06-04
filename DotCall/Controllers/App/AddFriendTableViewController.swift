//
//  AddFriendTableViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-02.
//

import UIKit
import Firebase

struct User {
    let username: String
    let email: String
    let name: String
}

class AddFriendTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var friendsList: [[String: Any]] = []
    private var text: String = "Make New Friends..."
    let currentUserEmail = Auth.auth().currentUser?.email
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        setupTableView()
        setupSearchController()
        
    }
    
    // MARK: - Actions
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        impactOccur()
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UISearchResultsUpdating
extension AddFriendTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }

        if searchText.isEmpty {
            friendsList.removeAll()
            text = "Make New Friends..."
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            findFriends(username: searchText) { (users, success, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if success {
                    if let users = users {
                        self.friendsList = users
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    self.friendsList.removeAll()
                    self.text = "💩 No Results"
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}





// MARK: - UITableViewDataSource

extension AddFriendTableViewController : AddFriendCellDelegate{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.isEmpty ? 1 : friendsList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if friendsList.isEmpty{
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if friendsList.isEmpty {
            let cell = CenteredTextTableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(text)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriend", for: indexPath) as! AddFriendCell
            
            cell.friendName.text = friendsList[indexPath.row]["name"] as? String
            cell.friendUsername.text = friendsList[indexPath.row]["username"] as? String
            cell.email =  (friendsList[indexPath.row]["email"] as? String)!
            cell.username =  (friendsList[indexPath.row]["username"] as? String)!
            cell.name =  (friendsList[indexPath.row]["name"] as? String)!
            cell.delegate = self
        
            return cell
        }
    }
    
    func addButtonPressed() {
        DispatchQueue.main.async {
            LoadingManager.shared.hideLoadingScreen()
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - UITableViewDelegate

extension AddFriendTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

// MARK: - Private Methods
private extension AddFriendTableViewController{
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionIndexColor = UIColor.themeText
        tableView.register(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriend")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search by username..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

    }
    private func impactOccur() {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func findFriends(username: String, completion: @escaping ([[String: Any]]?, Bool, Error?) -> Void) {
        // Prepare the URL
        let urlString = "https://dot-call-a7ff3d8633ee.herokuapp.com/friends/getAllFriends/\(username)"
        guard let url = URL(string: urlString) else {
            completion(nil, false, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion(nil, false, NSError(domain: "User email not found", code: 0, userInfo: nil))
            return
        }
        
        let requestBody: [String: Any] = ["email": currentUserEmail]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(nil, false, NSError(domain: "Failed to serialize request body", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, false, error)
                return
            }

            do {
                if let data = data,
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let matchingUsers = json["matchingUsers"] as? [[String: Any]] {

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




}
