//
//  String+Extension.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation

extension String {
    
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var upperCased: String {
        return uppercased()
    }
    var lowerCased: String {
        return lowercased()
    }
}
extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}
