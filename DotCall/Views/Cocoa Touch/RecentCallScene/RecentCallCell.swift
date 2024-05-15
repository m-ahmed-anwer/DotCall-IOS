//
//  RecentCallCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-03.
//

import UIKit

class RecentCallCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var callTime: UILabel!
    @IBOutlet weak var callType: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callType.setTitle("", for: .normal)
        callType.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        callType.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        contactImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
