//
//  MenuTableViewCell.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImages: UIImageView!
    @IBOutlet weak var menuFields: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
