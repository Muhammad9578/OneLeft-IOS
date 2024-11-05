//
//  ProfileViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .loadUsers, object: nil)
    }
    
    @objc func loadData() {
        let user = SharedManager.shared.user
        userNameLbl.text = user?.username ?? ""
        emailLbl.text = user?.email ?? ""
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.showContinueAlert(Strings.confirmation, message: Strings.logout_confirmation, continueHandler: { _ in
            SharedManager.shared.user = nil
            self.setRootVC(storyBoard: LoginViewController.identifier)
        }, cancelHandler: nil, continueTitle: "Yes", cancelTitle: "No")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        back()
    }
    
}
