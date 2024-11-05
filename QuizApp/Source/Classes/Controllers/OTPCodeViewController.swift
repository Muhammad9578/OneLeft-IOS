//
//  OTPCodeViewController.swift
//  QuizApp
//
//  Created by user on 25/09/2021.
//

import UIKit
import AEOTPTextField

class OTPCodeViewController: UIViewController {

    @IBOutlet weak var otpTextField: AEOTPTextField!
    
    var email = ""
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.otpDelegate = self
        otpTextField.configure(with: 4)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if code.count == 0 {
            self.showMessage(Strings.success, message: Strings.codeRequired)
        }else
        if code.count == 4 {
            Utility.startLoader()
            FirebaseUtility.verifyOtp(email: email, otpNumber: code) { isSuccess, message in
                Utility.stopLoader()
                if isSuccess {
                    self.showMessage(Strings.success, message: message) { _ in
                        Router.standard.navigateToCompleteYourProfileViewController(from: self.navigationController, email: self.email)
                    }
                }else {
                    self.showMessage(Strings.error, message: message)
                }
            }
        }
    }
    
    func resendCode() {
        FirebaseUtility.sendOtp(email: email) { isSuccess, message in
            Utility.stopLoader()
            if isSuccess {
                self.showMessage(Strings.success, message: message) { _ in
                    
                }
            }else {
                self.showMessage(Strings.error, message: message)
            }
        }
    }
    
}

extension OTPCodeViewController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        self.code = code
    }
}
