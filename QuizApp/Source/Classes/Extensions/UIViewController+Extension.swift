//
//  UIViewController+Extension.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import UIKit

extension UIViewController {
    // MARK: - UIAlertViewController (called from UIViewController)
    func showMessage(_ title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // set Root View Controller
    func setRootVC(storyBoard:String){
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: storyBoard)
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func showContinueAlert(_ title: String, message: String, continueHandler : (( UIAlertAction ) -> Void)?, cancelHandler : ((UIAlertAction) -> Void)?, continueTitle: String, cancelTitle: String, isCancel: Bool? = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: continueTitle, style: .default, handler: continueHandler)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        let closeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        if isCancel ?? false {
            alertController.addAction(closeAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}
