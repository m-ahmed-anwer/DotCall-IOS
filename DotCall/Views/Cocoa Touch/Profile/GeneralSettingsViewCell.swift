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

    

    // MARK: - Properties
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        self.shouldIndentWhileEditing = false
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors
    
    @objc func toggle(sender: UISwitch){
        if sender.isOn{
            print("ON")
        }else{
            print("OFf")
        }
    }
    
}
