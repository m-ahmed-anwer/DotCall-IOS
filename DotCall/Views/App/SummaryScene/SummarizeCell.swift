//
//  SummarizeCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import UIKit

class SummarizeCell: UITableViewCell {

    @IBOutlet weak var summarizeBubble: UIView!
    @IBOutlet weak var callRecieverText: UILabel!
    @IBOutlet weak var summarizeTitleText: UILabel!
    @IBOutlet weak var callTimeText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        userImage.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
