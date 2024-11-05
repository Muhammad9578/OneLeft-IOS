//
//  HomeTableViewCell.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var QuestionGames: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
