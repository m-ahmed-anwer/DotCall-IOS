//
//  SummaryByContactViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-18.
//

import UIKit


class SummaryByContactViewCell: UITableViewCell {
    
    var time:Date?{
        didSet {
            updateCallTimeText()
        }
    }

    
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateCallTimeText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let convertedDate =  time {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            
            let now = Date()
            let calendar = Calendar.current
            if calendar.isDateInToday(convertedDate) {
                dateFormatter.dateFormat = "HH:mm"
                timeText.text = "Today \(dateFormatter.string(from: convertedDate))"
            } else if calendar.isDateInYesterday(convertedDate) {
                dateFormatter.dateFormat = "HH:mm"
                timeText.text = "Yesterday \(dateFormatter.string(from: convertedDate))"
            } else if now.timeIntervalSince(convertedDate) < TimeInterval(7 * 24 * 3600) {
                let timeString = formatter.string(from: convertedDate, to: now)!
                dateFormatter.dateFormat = "HH:mm"
                timeText.text = "\(timeString)"
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                timeText.text = dateFormatter.string(from: convertedDate)
            }
        }else{
            timeText.text = "NaN"
        }
    }
    
    
}
