//
//  Router+Extension.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import UIKit

extension Router {
    
    private var mainStoryBoard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func signUpViewController() -> SignUpViewController {
        return controller(with: SignUpViewController.identifier) as! SignUpViewController
    }
    func homeViewController() -> HomeViewController {
        return controller(with: HomeViewController.identifier) as! HomeViewController
    }
    func profileViewController() -> ProfileViewController {
        return controller(with: ProfileViewController.identifier) as! ProfileViewController
    }
    func logInViewController() -> LoginViewController {
        return controller(with: LoginViewController.identifier) as! LoginViewController
    }
    func historyViewController() -> HistoryViewController {
        return controller(with: HistoryViewController.identifier) as! HistoryViewController
    }
    func otpCodeViewController() -> OTPCodeViewController {
        return controller(with: OTPCodeViewController.identifier) as! OTPCodeViewController
    }
    func paymentViewController() -> PaymentViewController {
        return controller(with: PaymentViewController.identifier) as! PaymentViewController
    }
    func termsOfServiceViewController() -> TermsOfServiceViewController {
        return controller(with: TermsOfServiceViewController.identifier) as! TermsOfServiceViewController
    }
    func questionnaireViewController() -> QuestionnaireViewController {
        return controller(with: QuestionnaireViewController.identifier) as! QuestionnaireViewController
    }
    func playersLoungeViewController() -> PlayersLoungeViewController {
        return controller(with: PlayersLoungeViewController.identifier) as! PlayersLoungeViewController
    }
    func playersLounge2ViewController() -> PlayersLounge2ViewController {
        return controller(with: PlayersLounge2ViewController.identifier) as! PlayersLounge2ViewController
    }
    func forgotPasswordViewController() -> ForgotPasswordViewController {
        return controller(with: ForgotPasswordViewController.identifier) as! ForgotPasswordViewController
    }
    func outOfGameViewController() -> OutOfGamePopViewController {
        return controller(with: OutOfGamePopViewController.identifier) as! OutOfGamePopViewController
    }
    func setUpStripeViewController() -> SetupStripeViewController {
        return controller(with: SetupStripeViewController.identifier) as! SetupStripeViewController
    }
    func game1ResultsViewController() -> Game1ResultsViewController {
        return controller(with: Game1ResultsViewController.identifier) as! Game1ResultsViewController
    }
    func completeYourProfileViewController() -> CompleteYourProfileViewController {
        return controller(with: CompleteYourProfileViewController.identifier) as! CompleteYourProfileViewController
    }
    func payPopUpViewController() -> PayPopupViewController {
        return controller(with: PayPopupViewController.identifier) as! PayPopupViewController
    }
    func contactUsViewController() -> ContactUsViewController {
        return controller(with: ContactUsViewController.identifier) as! ContactUsViewController
    }
    private func controller(with identifier: String) -> UIViewController? {
        return mainStoryBoard.instantiateViewController(identifier: identifier)
    }
}
