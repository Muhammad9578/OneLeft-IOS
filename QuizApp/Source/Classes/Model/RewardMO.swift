//
//  RewardMO.swift
//  QuizApp
//
//  Created by user on 04/12/2021.
//

import Foundation

class RewardMO: Mappable, Stringify {
    var game: String?
    var id: String?
    var name: String?
    var dateTime: Int64?
    var rewardEarned: Double?
    
    enum CodingKeys: String, CodingKey {
        case game = "game"
        case id = "id"
        case name = "name"
        case dateTime = "dateTime"
        case rewardEarned = "rewardEarned"
    }
    
    init(with json: [String: Any]) {
        self.game = json[CodingKeys.game.rawValue] as? String ?? ""
        self.id = json[CodingKeys.id.rawValue] as? String ?? ""
        self.name = json[CodingKeys.name.rawValue] as? String ?? ""
        self.rewardEarned = json[CodingKeys.rewardEarned.rawValue] as? Double ?? 0.0
        self.dateTime = json[CodingKeys.dateTime.rawValue] as? Int64 ?? 0
    }
}
