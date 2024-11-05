//
//  SharedManager.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation
import UIKit
class SharedManager {
    static var shared = SharedManager()
    
    private var defaults = UserDefaults.standard
    private init() {
        setup()
    }
    
    var deviceToken: String? = ""
    
    var user: UserMO? {
        didSet {
            syncUser()
        }
    }
    
    var isLoggedIn: Bool { return user != nil }
    
    func syncUser() {
        guard let user = user,
            let string = user.json
            else {
                defaults.removeObject(forKey: UserDefaultKeys.loggedInUser)
                return
        }
        defaults.set(string, forKey: UserDefaultKeys.loggedInUser)
    }

    
    private func setup() {
        if let userString = defaults.string(forKey: UserDefaultKeys.loggedInUser),
            let user = UserMO(jsonString: userString) {
            self.user = user
        }
    }
    func setRootVC(storyBoard: String){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(identifier: storyBoard)
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}
