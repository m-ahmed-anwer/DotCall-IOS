//
//  SummarizeCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import UIKit

class SummarizeCell: UITableViewCell {
    
    var time:Date? {
        didSet {
            updateCallTimeText()
        }
    }

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
    }
    
    
 
    // Function to update the callTimeText label based on the current value of the time property
    private func updateCallTimeText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let convertedDate = time {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let now = Date()
            let calendar = Calendar.current
            if calendar.isDateInToday(convertedDate) {
                dateFormatter.dateFormat = "HH:mm"
                callTimeText.text = dateFormatter.string(from: convertedDate)
            } else if calendar.isDateInYesterday(convertedDate) {
                callTimeText.text = "Yesterday"
            } else if now.timeIntervalSince(convertedDate) < TimeInterval(7 * 24 * 3600) {
                formatter.allowedUnits = [.day]
                callTimeText.text = formatter.string(from: convertedDate, to: now)
            } else {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                callTimeText.text = dateFormatter.string(from: convertedDate)
            }
        } else {
            callTimeText.text = "NaN"
        }
    }
}
