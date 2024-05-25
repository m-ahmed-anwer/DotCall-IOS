//
//  GeneralSettingsViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-11.
//

import UIKit

class GeneralSettingsViewCell: UITableViewCell {

    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            textLabel?.font = UIFont.systemFont(ofSize: 16)
            switchControl.isHidden = !sectionType.containSwitch
            if !sectionType.imageName.isEmpty {
                imageView?.image = UIImage(systemName: sectionType.imageName)
            }
        }
    }


    // MARK: - Properties
    
    lazy var switchControl: UISwitch = {
        let sectionType = sectionType
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchControl)  // Add switchControl to contentView
           
        switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true

       self.shouldIndentWhileEditing = false
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors
    
    @objc func toggle(sender: UISwitch){
        
        if let option = GeneralnOptions(rawValue: sectionType!.id){
            if sender.isOn {
                switch option {
                    case .notification:
                        UserProfile.shared.settingsProfile.notification = true
                    case .faceId:
                        UserProfile.shared.settingsProfile.faceId = true
                    case .haptic:
                        UserProfile.shared.settingsProfile.haptic = true
                        
                }
            }else{
                switch option {
                    case .notification:
                        UserProfile.shared.settingsProfile.notification = false
                    case .faceId:
                        UserProfile.shared.settingsProfile.faceId = false
                    case .haptic:
                        UserProfile.shared.settingsProfile.haptic = false
                }
            }
            updateGeneralSettings(
                userId: UserProfile.shared.generalProfile.id ?? "" ,
                notification: UserProfile.shared.settingsProfile.notification ?? false,
                faceId: UserProfile.shared.settingsProfile.faceId ?? false,
                haptic: UserProfile.shared.settingsProfile.haptic ?? false
            )
        }
    }
    
    func updateGeneralSettings(userId: String, notification: Bool, faceId: Bool, haptic: Bool) {

        let urlString = "https://dot-call-a7ff3d8633ee.herokuapp.com/users/editGeneralSettings/\(userId)"
        guard let url = URL(string: urlString) else { return }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the request body
        let requestBody: [String: Any] = [
            "notification": notification,
            "faceId": faceId,
            "haptic": haptic
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else { return }
        request.httpBody = httpBody

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            let defaults = UserDefaults.standard
            defaults.set(notification, forKey: "notification")
            defaults.set(faceId, forKey: "faceId")
            defaults.set(haptic, forKey: "haptic")
            defaults.synchronize()
        }
        task.resume()
    }


    
}
