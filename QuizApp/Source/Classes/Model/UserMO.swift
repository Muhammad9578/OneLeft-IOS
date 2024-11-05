//
//  UserMO.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation
class UserMO: Mappable, Stringify {
    var email: String?
    var phone: String?
    var image: String?
    var username: String?
    var id: String?
    var fcmToken: String?
    var answers: [AnswerMO]?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case phone = "phone"
        case image = "image"
        case username = "username"
        case fcmToken = "fcmToken"
        case id = "id"
    }
    
    init(with json: [String: Any]) {
        self.email = json[CodingKeys.email.rawValue] as? String ?? ""
        self.phone = json[CodingKeys.phone.rawValue] as? String ?? ""
        self.image = json[CodingKeys.image.rawValue] as? String ?? ""
        self.username = json[CodingKeys.username.rawValue] as? String ?? ""
        self.id = json[CodingKeys.id.rawValue] as? String ?? ""
        self.fcmToken = json[CodingKeys.fcmToken.rawValue] as? String ?? ""
    }
}
