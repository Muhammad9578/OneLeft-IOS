//
//  LoginViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    private var isValidate: Bool {
        guard let email = Email.text?.trim,
            let password = Password.text?.trim
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
        else if password.isEmpty {
            errorMessage = Strings.passwordRequired
        }
        if let errorMessage = errorMessage {
            showMessage(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SharedManager.shared.isLoggedIn {
            SharedManager.shared.setRootVC(storyBoard: HomeViewController.identifier)
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        Router.standard.navigateToForgotPasswordViewController(from: navigationController)
    }
    

    @IBAction func logInButtonTapped(_ sender: Any) {
        if isValidate {
            guard let email = Email.text,
                let password = Password.text
                else {
                    return
                }
            Utility.startLoader()
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    Utility.stopLoader()
                    self.showMessage(Strings.error, message: e.localizedDescription)
                } else {
                    let ref: DatabaseReference?
                    ref = Database.database().reference()
                    ref?.child(Strings.users).child(authResult?.user.uid ?? "").observeSingleEvent(of: DataEventType.value, with: { snapShot in
                        Utility.stopLoader()
                        if let value = snapShot.value as? [String : Any], value.count != 0 {
                            SharedManager.shared.user = UserMO(with: value)
                            Router.standard.navigateToHomeViewController(from: self.navigationController)
                        }else {
                            self.showMessage(Strings.error, message: Strings.userNotExist)
                        }
                    })
                }
            }
        }
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        Router.standard.navigateToSignUpViewController(from: self.navigationController)
    }
}
