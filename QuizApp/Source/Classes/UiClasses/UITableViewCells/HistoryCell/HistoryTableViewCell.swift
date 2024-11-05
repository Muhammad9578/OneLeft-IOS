//
//  HistoryTableViewCell.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    var reward: RewardMO? {
        didSet {
            gameName.text = reward?.game ?? ""
            rewardLbl.text = "Reward Earned: $\((reward?.rewardEarned ?? 0.0).rounded(toPlaces: 2))"
            dateLbl.text = Utility.getReadableDate(timeStamp: TimeInterval(reward?.dateTime ?? 0))
        }
    }
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
