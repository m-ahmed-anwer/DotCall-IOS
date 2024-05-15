//
//  SettingsViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-09.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            if !sectionType.imageName.isEmpty {
                imageView?.image = UIImage(systemName: sectionType.imageName)
            }
        }
    }
    
    var publicSectionType: PublicSectionType? {
        didSet {
            guard let sectionType = publicSectionType else { return }
            textLabel?.text = sectionType.description
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            if !sectionType.imageName.isEmpty {
                imageView?.image = UIImage(systemName: sectionType.imageName)
            }
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1 , reuseIdentifier: "SettingsCell" )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Your custom logic for when the cell is selected
    }
    
}

