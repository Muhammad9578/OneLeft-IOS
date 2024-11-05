//
//  game1ResultTableViewCell.swift
//  QuizApp
//
//  Created by user on 02/10/2021.
//

import UIKit

class game1ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var correctAnswersLbl: UILabel!
    @IBOutlet weak var attemptedQuestionsLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
