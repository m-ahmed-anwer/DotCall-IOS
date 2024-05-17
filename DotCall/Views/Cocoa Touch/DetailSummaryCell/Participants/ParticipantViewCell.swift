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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        contactImage.clipsToBounds = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func DetailButtonPressed(_ sender: UIButton) {
        // Find the tableView containing the cell
        var tableView: UITableView? = nil
        var view: UIView? = self
        while view != nil && tableView == nil {
            if let superView = view?.superview as? UITableView {
                tableView = superView
            } else {
                view = view?.superview
            }
        }
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        if let indexPath = tableView?.indexPath(for: self) {
            
            if indexPath.row == 0 {
                var responder: UIResponder? = self
                    while let nextResponder = responder?.next {
                        if let tabViewController = nextResponder as? TabViewController {
                            tabViewController.navigateToSettings()
                            break
                        }
                        responder = nextResponder
                    }
            }else{
                if let parentViewController = tableView?.delegate as? UIViewController {
                    let callStoryboard = UIStoryboard(name: "ContactProfile", bundle: nil)
                    if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "ContactProfiletoCheck") as? ContactProfileViewController {
                        callViewController.hidesBottomBarWhenPushed = true
                        callViewController.contactPhone = "768242884"
                        callViewController.contactEmail = "ahmedanwer0094@gmail.com"
                        callViewController.contactName = "Ahmed Anwer"
                        
                        parentViewController.navigationController?.pushViewController(callViewController, animated: true)
                    }
                }
            }
        }
    }

}
