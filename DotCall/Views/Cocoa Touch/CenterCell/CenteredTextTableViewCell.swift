//
//  CenteredTextTableViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-02.
//

import UIKit

class CenteredTextTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        textLabel?.textAlignment = .center
        textLabel?.numberOfLines = 0
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = contentView.bounds
    }
}
