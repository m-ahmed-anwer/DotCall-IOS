//
//  NameViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

import UIKit

class NameViewCell: UITableViewCell {
    var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: "NameViewCell" )
        
        textField = UITextField(frame: CGRect(x: 15, y: 0, width: contentView.frame.width - 30, height: contentView.frame.height))
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(textField)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
