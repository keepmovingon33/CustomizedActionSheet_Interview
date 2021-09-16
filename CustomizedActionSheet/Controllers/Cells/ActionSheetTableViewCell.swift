//
//  ActionSheetTableViewCell.swift
//  CustomizedActionSheet
//
//  Created by Sky on 16/09/2021.
//

import UIKit

class ActionSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "My Long Community"
        itemImageView.image = #imageLiteral(resourceName: "avatar")
        itemImageView.setBorder(color: .clear, width: 0, radius: 20)
    }

}
