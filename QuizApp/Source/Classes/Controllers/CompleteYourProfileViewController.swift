//
//  CompleteYourProfileViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CompleteYourProfileViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var email = ""
    
    private var isValidate: Bool {
        guard let userName = userNameTextField.text?.trim,
            let password = passwordTextField.text?.trim,
            let confirmPassword = confirmPasswordTextField.text?.trim
            else {
                showMessage(Strings.error, message: Strings.somethingWentWrong)
                return false
            }
        var errorMessage: String?
        if userName.isEmpty {
            errorMessage = Strings.emailRequired
        }
        else if password.isEmpty {
            errorMessage = Strings.passwordRequired
        }
        else if confirmPassword.isEmpty {
            errorMessage = Strings.confirmPasswordRequired
        }
        else if password != confirmPassword {
            errorMessage = Strings.passwordNotMatched
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
    
    @IBAction func completeTapped(_ sender: Any) {
        if isValidate {
            guard let userName = userNameTextField.text,
                let password = passwordTextField.text
                else {
                    return
                }
            Utility.startLoader()
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    Utility.stopLoader()
                    self.showMessage(Strings.error, message: error.localizedDescription)
                }else {
                    let ref: DatabaseReference?
                    ref = Database.database().reference()
                    if let uid = authResult?.user.uid {
                        let query = ref?.child(Strings.users).child(uid)
                        let data = [
                            "id": uid,
                            "email": self.email,
                            "username": userName
                        ]
                        query?.setValue(data, withCompletionBlock: { dataError, dataRef in
                            Utility.stopLoader()
                            let user = UserMO(with: data)
                            SharedManager.shared.user = user
                            if let dataError = dataError {
                                self.showMessage(Strings.error, message: dataError.localizedDescription)
                            }else {
                                let user = UserMO(with: data)
                                SharedManager.shared.user = user
                                Router.standard.navigateToTermsOfServiceViewController(from: self.navigationController, isNewUser: true)
                            }
                        })
                    }
                }
            }
            
        }
    }
    

}
