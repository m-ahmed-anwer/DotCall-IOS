//
//  ProfileViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-09.
//

import UIKit

class ContactProfileViewController: UIViewController {
    var contactName: String = ""
    var contactEmail: String = ""
    var contactPhone: String = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = .IOSBG
        
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(GeneralSettingsViewCell.self, forCellReuseIdentifier: "GeneralSettingsCell")
        tableView.register(UINib(nibName: "ProfileImageViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImageCell")
        navigationController?.navigationBar.tintColor = .backButton
        
       navigationItem.title = "\(contactName)"
      

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactProfileViewController: UITableViewDataSource,UITableViewDelegate{
  
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        guard let section = PublicProfileSection(rawValue: section) else {return 0}
        
        switch section{
            case .Image: return 1
            case .Profile: return PublicProfileOptions.allCases.count
            case .General: return PublicGeneralnOptions.allCases.count
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PublicProfileSection.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let section = PublicProfileSection(rawValue: section) else {return 0}
        
        switch section{
            case .Image: return 0
            case .Profile: return 40
            case .General: return 40
        }
    
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           guard let section = PublicProfileSection(rawValue: section) else { return UIView()}
           
           switch section{
               case .Image: return UIView()
           default:
               let view = UIView()
               view.backgroundColor = .IOSBG

               let title = UILabel()
               title.font = UIFont.systemFont(ofSize: 15)
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
        
        return UITableView.automaticDimension
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let section = PublicProfileSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageViewCell
            cell.backgroundColor = .clear
            
            cell.contactName.text = ""
            //cell.profileImage.image = UIImage(named: "your_profile_image_name")
            
            return cell
            
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
            
            let profile = PublicProfileOptions(rawValue: indexPath.row)
            cell.publicSectionType = profile
            cell.backgroundColor = UIColor.iosBoxBG
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.textAlignment = .right
            cell.selectionStyle = .none
        
            
            // Set the detail text based on the option
            switch profile {
            case .name:
                cell.detailTextLabel?.text = "\(contactName)"
            case .email:
                cell.detailTextLabel?.text = "ahmedanwer0094@gmail.com"
            case .phoneNumber:
                cell.detailTextLabel?.text = "\(contactPhone)"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingsCell", for: indexPath) as! GeneralSettingsViewCell

            
            if let general = PublicGeneralnOptions(rawValue: indexPath.row) {
                cell.publicSectionType = general
                cell.backgroundColor = UIColor.iosBoxBG
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
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
  
    
    
}
