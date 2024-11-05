//
//  SetupStripeViewController.swift
//  QuizApp
//
//  Created by user on 29/11/2021.
//

import UIKit
import Alamofire
import SafariServices
import NVActivityIndicatorView

class SetupStripeViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var detailsBtn: UILabel!
    @IBOutlet weak var setupBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    
    var accountUrl = ""
    var details_submitted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let account_id = UserDefaults.standard.string(forKey: Strings.account_id), !account_id.isEmpty {
            loader(isAnimate: true)
            let email = UserDefaults.standard.string(forKey: "email")
            emailTF.isEnabled = false
            print(account_id)
            emailTF.text = "\(account_id)(\(email ?? ""))"
            getAccountDetails(account_id: account_id)
            self.setupBtn.setTitle("Complete stripe setup", for: .normal)
            detailsBtn.isHidden = false
        }
    }
    
    func loader(isAnimate: Bool) {
        if isAnimate {
            setupBtn.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }else {
            setupBtn.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func getAccountId() {
        let encoding = URLEncoding.default
        let params = [
            "email": emailTF.text ?? ""
        ]
        let request = Alamofire.request("https://uppi.androidworkshop.net/stripe_api.php?action=create_account", method: .post, parameters: params, encoding: encoding, headers: [:])
        handleJSONResponse(for: request) { result, error in
            do {
                if let result = result {
                    let json = try JSONSerialization.jsonObject(with: result, options: []) as? [String : Any]
                    let account_id = json?["account_id"] as? String ?? ""
                    if !account_id.isEmpty {
                        UserDefaults.standard.setValue(self.emailTF.text ?? "", forKey: "email")
                        UserDefaults.standard.setValue(account_id, forKey: Strings.account_id)
                        self.getAccountDetails(account_id: account_id)
                        self.emailTF.isEnabled = false
                        self.emailTF.text = "\(account_id)(\(self.emailTF.text ?? ""))"
                    }
                }else  {
                    self.loader(isAnimate: false)
                    self.showMessage(Strings.error, message: error?.localizedDescription ?? "", handler: nil)
                }
            }
            catch
            {
                self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
            }
        }
    }
    
    func getAccountDetails(account_id: String) {
        let encoding = URLEncoding.default
        let params = [
            "account_id": account_id
        ]
        let request = Alamofire.request("https://uppi.androidworkshop.net/stripe_api.php?action=get_account_detail", method: .post, parameters: params, encoding: encoding, headers: [:])
        handleJSONResponse(for: request) { result, error in
            self.loader(isAnimate: false)
            do {
                if let result = result {
                    let json = try JSONSerialization.jsonObject(with: result, options: []) as? [String : Any]
                    let data = json?["account"] as? [String: Any]
                    self.details_submitted = data?["details_submitted"] as? Bool ?? false
                    self.accountUrl = json?["account_link"] as? String ?? ""
                    if self.details_submitted {
                        self.detailsBtn.text = "Your stripe account setup is complete"
                        self.setupBtn.isHidden = true
                    }else {
                        self.detailsBtn.isHidden = false
                        self.setupBtn.setTitle("Complete stripe setup", for: .normal)
                    }
                }else  {
                    self.showMessage(Strings.error, message: error?.localizedDescription ?? "", handler: nil)
                }
            }
            catch let error
            {
                self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
            }
        }
    }
    
    @IBAction func setupAccountTapped(_ sender: Any) {
        if let account_id = UserDefaults.standard.string(forKey: Strings.account_id), !account_id.isEmpty {
            if !self.details_submitted, !self.accountUrl.isEmpty {
                open(urlStr: self.accountUrl)
            }
        }else {
            loader(isAnimate: true)
            getAccountId()
        }
    }
    
    func open(urlStr: String) {
        if let url = URL(string: urlStr) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}
