//
//  ProfileViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-09.
//

import UIKit
import RealmSwift

class ContactProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    private var newSummaryUser: SummaryUser?
    
    internal var contactName: String = ""
    internal var contactEmail: String = ""
    internal var contactusername: String = ""
    internal var summaryRecent: String = "Loading Summary.."
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
        navigationController?.navigationBar.tintColor = .backButton
        navigationItem.title = "\(contactName)"
        setupTableView()
    }
    
}

// MARK: - Table View Data Source

extension ContactProfileViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = PublicProfileSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Image: return 1
        case .ChatCall: return 1
        case .Profile: return PublicProfileOptions.allCases.count
        case .General: return PublicGeneralnOptions.allCases.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PublicProfileSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = PublicProfileSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Image, .ChatCall: return 0
        default: return 40
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = PublicProfileSection(rawValue: section) else { return UIView() }
        
        switch section {
        case .Image, .ChatCall: return UIView()
        default:
            let view = UIView()
            view.backgroundColor = .IOSBG

            let title = UILabel()
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = .sectionHeader
            title.text = PublicProfileSection(rawValue: section.rawValue)?.description
            view.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

            return view
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = PublicProfileSection(rawValue: indexPath.section) {
            switch section {
            case .Profile:
                return 53
            case .General:
                return 58
            default:
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = PublicProfileSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactProfileViewCell", for: indexPath) as! ContactProfileViewCell
            cell.backgroundColor = .clear
            // cell.profileImage.image = UIImage(named: "Profile")
            return cell
        case .ChatCall:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCallViewCell", for: indexPath) as! ChatCallViewCell
            cell.backgroundColor = .clear
            cell.callButton.addTarget(self, action: #selector(callButtonPressed(_:)), for: .touchUpInside)
            cell.chatButton.addTarget(self, action: #selector(summaryButtonPressed(_:)), for: .touchUpInside)
            return cell
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
            let profile = PublicProfileOptions(rawValue: indexPath.row)
            cell.publicSectionType = profile
            cell.backgroundColor = UIColor.iosBoxBG
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.textAlignment = .right
            cell.selectionStyle = .none
        
            // Set the detail text based on the option
            switch profile {
            case .name:
                cell.detailTextLabel?.text = "\(contactName)"
            case .username:
                cell.detailTextLabel?.text = "\(contactusername)"
            default:
                cell.detailTextLabel?.text = ""
            }
            
            // Set the image
            if let imageName = profile?.imageName {
                cell.imageView?.image = UIImage(systemName: imageName)
                cell.imageView?.tintColor = .backButton
            }
            
            return cell
            
        case .General:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicProfileViewCell", for: indexPath) as! PublicProfileViewCell
            if let general = PublicGeneralnOptions(rawValue: indexPath.row) {
                cell.publicSectionType = general
                cell.inputViewController?.hidesBottomBarWhenPushed = true
                cell.backgroundColor = UIColor.iosBoxBG
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.selectionStyle = .none
                
                if !general.imageName.isEmpty {
                    cell.imageView?.image = UIImage(systemName: general.imageName)
                    cell.imageView?.tintColor = .backButton
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Button Actions
    
    @objc func callButtonPressed(_ sender: UIButton) {
        //saveSummary(contactName: contactName, recentSummary: summaryRecent)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "voiceCall", sender: nil)
        }
    }
    
    @objc func summaryButtonPressed(_ sender: UIButton) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        self.performSegue(withIdentifier: "SummariesCheck", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "voiceCall" {
            let destinationVC = segue.destination as? CallViewController
            destinationVC!.selectedSummary = newSummaryUser
        }
        
        if segue.identifier == "SummariesCheck" {
            let destinationVC = segue.destination as? SummarybyContactViewController
            destinationVC!.username = contactusername
        }
    }
}

// MARK: - Private Methods

private extension ContactProfileViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.backgroundColor = .IOSBG
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(PublicProfileViewCell.self, forCellReuseIdentifier: "PublicProfileViewCell")
        tableView.register(UINib(nibName: "ContactProfileViewCell", bundle: nil), forCellReuseIdentifier: "ContactProfileViewCell")
        tableView.register(UINib(nibName: "ChatCallViewCell", bundle: nil), forCellReuseIdentifier: "ChatCallViewCell")
    }
    
//    private func saveSummary(contactName: String, recentSummary: String) {
//        let summary = realm.objects(SummaryUser.self).filter("callReciverPhoneNum == %@", contactPhone)
//        let date = Date()
//        
//        do {
//            if summary.isEmpty {
//                let newSummaryUser = SummaryUser()
//                newSummaryUser.callReciverName = contactName
//                newSummaryUser.recentSummary = recentSummary
//                newSummaryUser.recentTime = date
//                try realm.write {
//                    realm.add(newSummaryUser)
//                }
//                self.newSummaryUser = newSummaryUser
//                print("Saved new summaryUser")
//            } else {
//                if let existingSummaryUser = summary.first {
//                    try realm.write {
//                        existingSummaryUser.recentTime = date
//                        existingSummaryUser.recentSummary = recentSummary
//                    }
//                    self.newSummaryUser = existingSummaryUser
//                    print("Updated existing summaryUser")
//                }
//            }
//        } catch {
//            print("Error saving summary: \(error.localizedDescription)")
//        }
//    }
}
