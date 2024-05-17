//
//  PublicProfileViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import UIKit

class PublicProfileViewCell: UITableViewCell {
    
    var publicSectionType: PublicSectionType? {
        didSet {
            guard let publicSectionType = publicSectionType else { return }
            textLabel?.text = publicSectionType.description
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            switchControl.isHidden = !publicSectionType.containSwitch
            if !publicSectionType.imageName.isEmpty {
                imageView?.image = UIImage(systemName: publicSectionType.imageName)
            }
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return switchControl
    }()

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
        if let publicOption = publicSectionType {
            if sender.isOn {
                print("Switch in section \(publicOption.description) turned ON")
            } else {
                print("Switch in section \(publicOption.description) turned OFF")
            }
        }
    }

}

