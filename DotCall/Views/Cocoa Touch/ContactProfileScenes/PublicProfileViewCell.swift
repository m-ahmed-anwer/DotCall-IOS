//
//  PublicProfileViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import UIKit

protocol PublicProfileViewCellDelegate: AnyObject {
    func didToggleRecordSwitch(isOn: Bool)
}


class PublicProfileViewCell: UITableViewCell {

    weak var delegate: PublicProfileViewCellDelegate?

    var publicSectionType: PublicSectionType? {
        didSet {
            guard let publicSectionType = publicSectionType else { return }
            textLabel?.text = publicSectionType.description
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            
            switchControl.isHidden = !publicSectionType.containSwitch
            switchControl.isEnabled = publicSectionType.description != PublicGeneralnOptions.friendrecord.description

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

        contentView.addSubview(switchControl)

        switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true

        self.shouldIndentWhileEditing = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func toggle(sender: UISwitch) {
        if let publicOption = publicSectionType {
            switch publicOption.description {
            case PublicGeneralnOptions.record.description:
                delegate?.didToggleRecordSwitch(isOn: sender.isOn)
            default:
                break
            }
        }
    }
}
