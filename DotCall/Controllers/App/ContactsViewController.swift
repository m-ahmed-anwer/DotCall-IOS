//
//  ContactsViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import Contacts
import ContactsUI
import UIKit

class ContactsViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var sectionTitle = [String]()
    private var contactDict = [String: [CNContact]]()
    private var contacts = [CNContact]()
    
    private var filteredContacts = [CNContact]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        fetchAllContact()
    }
    
    
    
    private func updateContactDictionary() {
        sectionTitle = Array(Set(contacts.compactMap({ String($0.givenName.prefix(1)) })))
        sectionTitle.sort()
        sectionTitle.forEach({ contactDict[$0] = [CNContact]() })
        contacts.forEach({ contactDict[String($0.givenName.prefix(1))]?.append($0) })
    }
    
    // MARK: - Actions
    
    @IBAction func GroupCallButtonPressed(_ sender: UIBarButtonItem) {
        impactOccur()
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
    @IBAction func plusIconPressed(_ sender: UIBarButtonItem) {
        impactOccur()
        let contactVC = CNContactViewController(forNewContact: nil)
        contactVC.delegate = self
        let navController = UINavigationController(rootViewController: contactVC)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - CNContactViewControllerDelegate
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if let newContact = contact {
            contacts.append(newContact)
            updateContactDictionary()
            tableView.reloadData()
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.isEmpty {
            filteredContacts = contacts
        } else {
            filteredContacts = contacts.filter { contact in
                return contact.givenName.lowercased().contains(searchText.lowercased()) ||
                    contact.familyName.lowercased().contains(searchText.lowercased())
            }
        }
        
        filteredContacts.sort { (contact1, contact2) -> Bool in
            let fullName1 = "\(contact1.givenName) \(contact1.familyName)"
            let fullName2 = "\(contact2.givenName) \(contact2.familyName)"
            return fullName1.localizedCaseInsensitiveCompare(fullName2) == .orderedAscending
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredContacts.count
        } else {
            let key = sectionTitle[section]
            return contactDict[key]?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseContact", for: indexPath) as! ContactCell

        let contact: CNContact
        if searchController.isActive {
            contact = filteredContacts[indexPath.row]
        } else {
            let key = sectionTitle[indexPath.section]
            if let contactsInSection = contactDict[key] {
                contact = contactsInSection[indexPath.row]
            } else {
                return cell
            }
        }
        let name = "\(contact.givenName) \(contact.familyName)"
        cell.contactName?.text = name
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? nil : sectionTitle[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : sectionTitle
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.themeText
    }
}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            let contact = filteredContacts[indexPath.row]
            impactOccur()
            let callStoryboard = UIStoryboard(name: "AppStoryboard", bundle: nil)
            if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "ContactProfiletoCheck") as? ContactProfileViewController {
                
                // Set the contact name and image
                callViewController.contactPhone = (contact.phoneNumbers.first?.value.stringValue.digits)!
                callViewController.contactName = "\(contact.givenName) \(contact.familyName)"
                
                // Push the callViewController
                navigationController!.pushViewController(callViewController, animated: true)
            }
            
        } else {
            let key = sectionTitle[indexPath.section]
            if let contactsInSection = contactDict[key] {
                let contact = contactsInSection[indexPath.row]
                impactOccur()
                
                let callStoryboard = UIStoryboard(name: "AppStoryboard", bundle: nil)
                if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "ContactProfiletoCheck") as? ContactProfileViewController {
                    
                    // Set the contact name and image
                    callViewController.contactPhone = (contact.phoneNumbers.first?.value.stringValue.digits)!
                    callViewController.contactName = "\(contact.givenName) \(contact.familyName)"
                    
                    // Push the callViewController
                    navigationController!.pushViewController(callViewController, animated: true)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - String Extension

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}


// MARK: - Private Methods

private extension ContactsViewController{
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionIndexColor = UIColor.themeText
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by names"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func fetchAllContact() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        DispatchQueue.global().async {
            do {
                try store.enumerateContacts(with: fetchRequest) { (contact, _) in
                    if !contact.givenName.isEmpty || !contact.familyName.isEmpty {
                        self.contacts.append(contact)
                    }
                }
                DispatchQueue.main.async {
                    self.updateContactDictionary()
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching contacts: \(error.localizedDescription)")
            }
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
