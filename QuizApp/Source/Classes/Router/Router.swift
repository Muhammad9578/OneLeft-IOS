//
//  Router.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//


import UIKit

class Router {
    static let standard = Router()
    
    func navigateToSignUpViewController(from navigationController: UINavigationController?) {
        let signUpController = signUpViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(signUpController, animated: true)
    }
    func navigateToHistoryViewController(from navigationController: UINavigationController?) {
        let HistoryController = historyViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(HistoryController, animated: true)
    }
    func navigateToPaymentViewController(from navigationController: UINavigationController?) {
        let PaymentController = paymentViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(PaymentController, animated: true)
    }
    func navigateToLogInViewController(from navigationController: UINavigationController?) {
        let LoginController = logInViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(LoginController, animated: true)
    }
    func navigateToHomeViewController(from navigationController: UINavigationController?) {
        let HomeController = homeViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(HomeController, animated: true)
    }
    func navigateToProfileViewController(from navigationController: UINavigationController?) {
        let ProfileController = profileViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(ProfileController, animated: true)
    }
    func navigateToQuestionnaireViewController(from navigationController: UINavigationController?, room: RoomMO?, game: String) {
        let questionnaireController = questionnaireViewController()
        questionnaireController.room = room
        questionnaireController.game = game
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(questionnaireController, animated: true)
    }
    
    func navigateToGame1ResultsViewController(from navigationController: UINavigationController?, room: RoomMO?) {
        let game1ResultsController = game1ResultsViewController()
        game1ResultsController.room = room
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(game1ResultsController, animated: true)
    }
    func navigateToTermsOfServiceViewController(from navigationController: UINavigationController?, isNewUser: Bool) {
        let TermsOfServiceController = termsOfServiceViewController()
        TermsOfServiceController.isNewUser = isNewUser
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(TermsOfServiceController, animated: true)
    }
    func navigateToOtpCodeViewController(from navigationController: UINavigationController?, email: String) {
        let otpCodeController = otpCodeViewController()
        navigationController?.isNavigationBarHidden = true
        otpCodeController.email = email
        navigationController?.pushViewController(otpCodeController, animated: true)
    }
    func navigateToCompleteYourProfileViewController(from navigationController: UINavigationController?, email: String) {
        let CompleteYourProfileController = completeYourProfileViewController()
        navigationController?.isNavigationBarHidden = true
        CompleteYourProfileController.email = email
        navigationController?.pushViewController(CompleteYourProfileController, animated: true)
    }
    func navigateToContactUsProfileViewController(from navigationController: UINavigationController?) {
        let ContactUsController = contactUsViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController( ContactUsController, animated: true)
    }
    func navigateToSetupStripeViewController(from navigationController: UINavigationController?) {
        let SetupStripeController = setUpStripeViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController( SetupStripeController, animated: true)
    }
    func navigateToPlayersLoungeViewController(from navigationController: UINavigationController?) {
        let playersLoungeController = playersLoungeViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(playersLoungeController, animated: true)
    }
    func navigateToForgotPasswordViewController(from navigationController: UINavigationController?) {
        let forgotPasswordController = forgotPasswordViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(forgotPasswordController, animated: true)
    }
    func navigateToPlayersLounge2ViewController(from navigationController: UINavigationController?) {
        let playersLounge2Controller = playersLounge2ViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(playersLounge2Controller, animated: true)
    }
    func showPayPopUpViewController(from viewController: UIViewController?, delegate: PaymentPopDelegate, index: Int) {
        let customPopController = payPopUpViewController()
        customPopController.delegate = delegate
        customPopController.index = index
        customPopController.modalTransitionStyle = .crossDissolve
        customPopController.modalPresentationStyle = .overFullScreen
        viewController?.present(customPopController, animated: true, completion: nil)
    }
    func showOutOfGameViewController(from viewController: UIViewController?, delegate: OutOfGameDelegate, noAnswer: Bool) {
        let outOfGameController = outOfGameViewController()
        outOfGameController.noAnswer = noAnswer
        outOfGameController.delegate = delegate
        outOfGameController.modalTransitionStyle = .crossDissolve
        outOfGameController.modalPresentationStyle = .overFullScreen
        viewController?.present(outOfGameController, animated: true, completion: nil)
    }
    
    func navigateBackToHomeOrPlatform(from navigationController: UINavigationController?) {
        for controller in navigationController!.viewControllers
        {
            if let vc = controller as? HomeViewController {
                navigationController?.popToViewController(vc, animated:    true)
                break
            }else
            if let vc = controller as? PlayersLoungeViewController
            {
                navigationController?.popToViewController(vc, animated:    true)
                break
            }else
            if let vc = controller as? PlayersLounge2ViewController
            {
                navigationController?.popToViewController(vc, animated:    true)
                break
            }
            
        }
    }

}
