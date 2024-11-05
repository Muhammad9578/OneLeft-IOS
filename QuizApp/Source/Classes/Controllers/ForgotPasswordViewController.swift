//
//  ForgotPasswordViewController.swift
//  QuizApp
//
//  Created by user on 04/12/2021.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    private var isValidate: Bool {
        guard let email = emailTF.text?.trim
        else {
            showMessage(Strings.error, message: Strings.somethingWentWrong)
            return false
        }
        var errorMessage: String?
        if email.isEmpty {
            errorMessage = Strings.emailRequired
        }
        else if !email.isValidEmail {
            errorMessage = Strings.invalidEmailFormat
        }
        if let errorMessage = errorMessage {
            showMessage(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        if isValidate {
            guard let email = emailTF.text
            else {
                showMessage(Strings.error, message: Strings.somethingWentWrong)
                return
            }
            Utility.startLoader()
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                Utility.stopLoader()
                if let error = error {
                    self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
                }else {
                    self.showMessage(Strings.success, message: Strings.resetPasswordLinkSent) { _ in
                        self.back()
                    }
                }
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    

}
