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
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            switchControl.isHidden = !sectionType.containSwitch
            if !sectionType.imageName.isEmpty {
                imageView?.image = UIImage(systemName: sectionType.imageName)
            }
        }
    }

    

    // MARK: - Properties
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
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
        }
    }

    
}
