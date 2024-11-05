//
//  SignUpViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
typealias httpParameters = [String: Any]
class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var ConfirmEmail: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    var isAgree = false
    
    private var isValidate: Bool {
        guard let email = Email.text?.trim,
              let confirmEmail = ConfirmEmail.text?.trim
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
        else if confirmEmail.isEmpty {
            errorMessage = Strings.confirmEmailRequired
        }
        else if !confirmEmail.isValidEmail {
            errorMessage = Strings.invalidEmailFormat
        }
        else if email != confirmEmail {
            errorMessage = Strings.emailNotMatched
        }
        if let errorMessage = errorMessage {
            showMessage(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        back()
    }
    
    @IBAction func agreeTCTapped(_ sender: Any) {
        isAgree = !isAgree
        checkImage.image = isAgree ? UIImage(named: "checked"): UIImage(named: "unChecked")
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = Email.text
        else {
            return
        }
        if isValidate {
            Utility.startLoader()
            let ref = Database.database().reference()
            ref.child(Strings.users).queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapShot in
                if let _ = snapShot.value as? NSDictionary {
                    Utility.stopLoader()
                    self.showMessage(Strings.appName, message: Strings.emailAlreadyExists)
                }else {
                    FirebaseUtility.sendOtp(email: email) { isSuccess, message in
                        Utility.stopLoader()
                        if isSuccess {
                            self.showMessage(Strings.success, message: message) { _ in
                                Router.standard.navigateToOtpCodeViewController(from: self.navigationController, email: email)
                            }
                        }else {
                            self.showMessage(Strings.error, message: message)
                        }
                    }
                }
            }
        }
    }
}
