//
//  ContactCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-03.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callButton.setTitle("", for: .normal)
        callButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        callButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

     
        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        contactImage.clipsToBounds = true
    }

    @IBAction func CallButtonPressed(_ sender: UIButton) {}


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
