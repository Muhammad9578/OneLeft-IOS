//
//  HomeViewController.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit
import MessageUI

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var fullDismissButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    var QuestionGame = ["Game 1","Game 2"]
    var MenuNames = ["Home","My Profile","Stripe Account","History","Terms of service","Contact Us"]
    var MenuIcons = ["home","user","dollar","history","terms-and-conditions","comment"]
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseUtility.getAllUsersData()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: MenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier:  MenuTableViewCell.identifier)
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .loadUsers, object: nil)
    }
    
    @objc func loadData() {
        let user = SharedManager.shared.user
        userNameLbl.text = user?.username ?? ""
    }
    
    @IBAction func showMenuButtonTapped(_ sender: Any) {
        self.menuView.isHidden = false
        UIView.animate(withDuration: 0.7) {
            self.menuLeading.constant = 0
            self.fullDismissButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func game1Tapped(_ sender: Any) {
        Router.standard.navigateToPlayersLoungeViewController(from: navigationController)
    }
    @IBAction func game2Tapped(_ sender: Any) {
        Router.standard.navigateToPlayersLounge2ViewController(from: navigationController)
    }
    
    
    @IBAction func dismissMenuButtonTapped(_ sender: Any) {
        dismissMenu()
    }
    func dismissMenu() {
        UIView.animate(withDuration: 0.7) {
            self.menuLeading.constant = -300
            self.fullDismissButton.isHidden = true
            self.view.layoutIfNeeded()
        } completion: { (isCompletion) in
            if isCompletion {
                self.menuView.isHidden = true
            }
        }
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell() // Dummy value
        if tableView == self.menuTableView {
            let cell = menuTableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier) as! MenuTableViewCell
            let name = MenuIcons[indexPath.row]
            cell.menuImages.image = UIImage(named: name)
            cell.menuFields.text = MenuNames[indexPath.row]
            cellToReturn = cell
        }
        
        return cellToReturn
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissMenu()
        if indexPath.row == 1 {
            Router.standard.navigateToProfileViewController(from: navigationController)
            
        }else if indexPath.row == 2  {
            Router.standard.navigateToSetupStripeViewController(from: navigationController)
        }
        else if indexPath.row == 3 {
            Router.standard.navigateToHistoryViewController(from: navigationController)
            
        }
        if indexPath.row == 4 {
            Router.standard.navigateToTermsOfServiceViewController(from: navigationController, isNewUser: false)
        }
        if indexPath.row == 5 {
            openMail()
        }
    }
}

//extension HomeViewController: PaymentPopDelegate {
//    func payClicked(index: Int) {
//        if index == 0 {
//            
//        }else if index == 1 {
//            
//        }
//    }
//}

extension HomeViewController: MFMailComposeViewControllerDelegate {
    func openMail() {
        let recipientEmail = "oneleftapp@gmail.com"
        let subject = "OneLeft Feedback"
        let body = ""
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
