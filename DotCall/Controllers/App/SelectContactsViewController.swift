//
//  SelectContactsViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit
import Contacts

class SelectContactsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var groupCallButton: UIButton!

    // MARK: - Properties

    private var contacts = [CNContact]()
    private var selectedContacts = [CNContact]()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }

    // MARK: - Fetch Contacts

    private func fetchContacts() {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]

        do {
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { (contact, _) in
                self.contacts.append(contact)
            }
            tableView.reloadData()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }

    // MARK: - Button Actions

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func groupCallButtonTapped(_ sender: UIButton) {
        // Implement logic to make a group call using selectedContacts array
        print("Group call button tapped")
    }

}

// MARK: - Table View Data Source

extension SelectContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"

        // Add checkbox to the left side of the cell
        let checkBox = UIButton(type: .custom)
        checkBox.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        checkBox.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        checkBox.setImage(UIImage(named: "checkbox_checked"), for: .selected)
        checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkBox.tag = indexPath.row
        checkBox.isSelected = selectedContacts.contains(where: { $0.identifier == contact.identifier })
        cell.contentView.addSubview(checkBox)

        return cell
    }

    @objc func checkBoxTapped(_ sender: UIButton) {
        let contact = contacts[sender.tag]
        if let index = selectedContacts.firstIndex(where: { $0.identifier == contact.identifier }) {
            selectedContacts.remove(at: index)
        } else {
            selectedContacts.append(contact)
        }

        sender.isSelected = !sender.isSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row since we are using custom selection with checkboxes
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
