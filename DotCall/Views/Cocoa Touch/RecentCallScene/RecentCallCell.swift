//
//  RecentCallCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-03.
//

import UIKit

class RecentCallCell: UITableViewCell {
    
    var time: Date? {
        didSet {
            updateCallTimeText()
        }
    }
    @IBOutlet weak var recentView: UIView!
    
    var type: String? {
        didSet {
            switch type {
            case "Incoming":
                callTime.textColor = .systemGray
                contactName.textColor = .label
                callType.setImage(UIImage(named: "phoneDOWN"), for: .normal)
                
            case "Outgoing":
                callTime.textColor = .systemGray
                contactName.textColor = .label
                callType.setImage(UIImage(named: "phoneUP"), for: .normal)
                
            case "Missed":
                callTime.textColor = .systemRed
                contactName.textColor = .systemRed
                callType.setImage(UIImage(named: "phoneDownMiss"), for: .normal)
            default:
                break
            }
        }
    }

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
    
    func updateTime(_ newTime: Date) {
        time = newTime
    }
    
    private func updateCallTimeText() {
        guard let time = time else {
            callTime.text = "NaN"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = Date()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(time) {
            let components = calendar.dateComponents([.hour, .minute], from: time, to: now)
            if let hour = components.hour, hour > 0 {
                callTime.text = "\(hour) hour\(hour > 1 ? "s" : "") ago"
            } else if let minute = components.minute, minute > 0 {
                callTime.text = "\(minute) minute\(minute > 1 ? "s" : "") ago"
            } else {
                callTime.text = "Just now"
            }
        } else if calendar.isDateInYesterday(time) {
            callTime.text = "Yesterday"
        } else if now.timeIntervalSince(time) < TimeInterval(7 * 24 * 3600) {
            let components = calendar.dateComponents([.day], from: time, to: now)
            if let days = components.day, let weekday = calendar.dateComponents([.weekday], from: time).weekday {
                if days == 1 {
                    callTime.text = "Yesterday"
                } else if days < 7 {
                    let weekdayName = calendar.weekdaySymbols[(weekday - 1) % 7]
                    callTime.text = weekdayName
                }
            }
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            callTime.text = dateFormatter.string(from: time)
        }
    }
}
