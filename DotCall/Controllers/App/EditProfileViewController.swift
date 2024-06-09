//
//  EditProfileViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-11.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateUserProfile()
}


class EditProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameFeild: UITextField!
    
    // MARK: - Properties
    weak var delegate: EditProfileDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .backButton
        navigationItem.leftBarButtonItem?.tintColor = .backButton
        setupTableView()
    }
    
    // MARK: - Actions
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        guard let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NameViewCell,
             let name = nameCell.textField.text, !name.isEmpty else {
              showAlert(title: "Error", message: "Name cannot be empty")
              return
        }

        
        updateProfile(userId: UserProfile.shared.generalProfile.id ?? "" ,name: name)
    }
    
    


}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameViewCell", for: indexPath) as! NameViewCell
        cell.backgroundColor = .iosBoxBG
    
        cell.textField.placeholder = "Enter name"
        cell.textField.text = UserProfile.shared.generalProfile.name
        cell.textField.autocapitalizationType = .words
        cell.textField.textContentType = .name
        cell.selectionStyle = .none // Disable cell selection
        
        return cell
    }



    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Name"
    }
    
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 30, height: 50))
        label.text = "Your name will be displayed to other users."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        footerView.addSubview(label)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

extension EditProfileViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - Private Methods

private extension EditProfileViewController{
    
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    private func updateProfile(userId: String, name: String) {
        LoadingManager.shared.showLoadingScreen()
        let urlString = "https://dot-call-a7ff3d8633ee.herokuapp.com/users/editProfile/\(userId)"
        guard let url = URL(string: urlString) else { return }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the request body
        let requestBody: [String: Any] = [
            "name": name,
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else { return }
        request.httpBody = httpBody

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                LoadingManager.shared.hideLoadingScreen()
                print("Error: \(error)")
                return
            }
            UserProfile.shared.generalProfile.name = name
            
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "userName")
            defaults.synchronize()
            
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                self.delegate?.didUpdateUserProfile()
                self.navigationController?.popViewController(animated: true)
            }
        }
        task.resume()
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NameViewCell.self, forCellReuseIdentifier: "NameViewCell")
    }
}
