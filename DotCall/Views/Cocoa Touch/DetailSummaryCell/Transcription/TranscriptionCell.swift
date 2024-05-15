//
//  TranscriptionCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit

class TranscriptionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var transcriptionText: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
