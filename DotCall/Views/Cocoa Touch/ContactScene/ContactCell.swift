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

    @IBAction func CallButtonPressed(_ sender: UIButton) {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                if let navigationController = viewController.navigationController {
                    let callStoryboard = UIStoryboard(name: "CallStoryboard", bundle: nil)
                    if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "CallViewControllerIdentifier") as? CallViewController {
                        
                        // Set the contact name and image
                        callViewController.contactName = contactName.text
                        callViewController.contactImage = contactImage.image
                        
                        // Push the callViewController
                        navigationController.pushViewController(callViewController, animated: true)
                    }
                    break
                }
            }
            responder = nextResponder
        }
    }


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
