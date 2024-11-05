//
//  OutOfGamePopViewController.swift
//  QuizApp
//
//  Created by user on 21/11/2021.
//

import UIKit

protocol OutOfGameDelegate {
    func leaveGame()
}

class OutOfGamePopViewController: BaseViewController {

    @IBOutlet weak var detailLbl: UILabel!
    var delegate: OutOfGameDelegate?
    
    var noAnswer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if noAnswer {
            detailLbl.text = "Oops! You did not answer this question \n Sorry, you are out of the game"
        }else {
            detailLbl.text = "Oops! You did wrong answer of this question \n Sorry, you are out of the game"
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss()
        delegate?.leaveGame()
    }
    
    @IBAction func okTapped(_ sender: Any) {
        dismiss()
        delegate?.leaveGame()
    }
}
