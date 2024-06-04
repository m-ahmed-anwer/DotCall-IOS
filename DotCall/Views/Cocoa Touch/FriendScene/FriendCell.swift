//
//  ContactCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-03.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        contactImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
