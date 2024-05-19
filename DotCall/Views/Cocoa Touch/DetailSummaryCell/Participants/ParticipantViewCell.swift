//
//  ParticipantViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-16.
//

import UIKit

class ParticipantViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var profileButton: UIButton!
    
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
