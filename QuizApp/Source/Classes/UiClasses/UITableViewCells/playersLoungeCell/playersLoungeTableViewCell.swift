//
//  playersLoungeTableViewCell.swift
//  QuizApp
//
//  Created by user on 01/10/2021.
//

import UIKit

class playersLoungeTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
