//
//  EditProfileViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-11.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var nameFeild: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NameViewCell.self, forCellReuseIdentifier: "NameViewCell")
        navigationController?.navigationBar.tintColor = .backButton
        navigationItem.leftBarButtonItem?.tintColor = .backButton

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NameViewCell,
             let name = nameCell.textField.text, !name.isEmpty else {
              showAlert(title: "Error", message: "Name cannot be empty")
              return
        }

        guard let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? NameViewCell,
             let email = emailCell.textField.text, !email.isEmpty, isValidEmail(email) else {
              showAlert(title: "Error", message: "Please enter a valid email address")
              return
        }

        // Save the name and email
        print("Name: \(name), Email: \(email)")
        navigationController?.popViewController(animated: true)
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression for basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    

}
extension EditProfileViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameViewCell", for: indexPath) as! NameViewCell
        cell.backgroundColor = .iosBoxBG
        if indexPath.section == 0 {
            cell.textField.placeholder = "Enter name"
            cell.textField.text = "Ahmed Anwer"
        } else if indexPath.section == 1 {
            cell.textField.placeholder = "Enter email"
            cell.textField.text = "ahmedanwer0094@gmail.com"
        }
        
        cell.selectionStyle = .none // Disable cell selection
        return cell
    }



    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
               return "Name"
           } else if section == 1 {
               return "Email"
           }
           
           return nil
    }
    
    
    
}
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 30, height: 50))
            label.text = "Make sure to you use a valid email address."
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            footerView.addSubview(label)
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
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
