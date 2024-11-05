//
//  RoomMO.swift
//  QuizApp
//
//  Created by user on 01/10/2021.
//

import Foundation
class RoomMO: Mappable, Stringify {
    var status: String?
    var id: String?
    var userList: [UserMO]?
    var creationTime: Int64?
    var gameScheduleTime: Int64?
    var gameEnded: Bool?
    var gameStarted: Bool?
    var lastActivityTime: Int64?
    var gameScheduleDate: Date?
    var totalPlayersJoined: Int?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case id = "id"
        case userList = "userList"
        case creationTime = "creationTime"
        case gameScheduleTime = "gameScheduleTime"
        case lastActivityTime = "lastActivityTime"
        case gameEnded =  "gameEnded"
        case gameStarted = "gameStarted"
        case totalPlayersJoined = "totalPlayersJoined"
    }
    
    init(with json: [String: Any]) {
        self.status = json[CodingKeys.status.rawValue] as? String ?? ""
        self.id = json[CodingKeys.id.rawValue] as? String ?? ""
        self.creationTime = json[CodingKeys.creationTime.rawValue] as? Int64 ?? 0
        self.gameScheduleTime = json[CodingKeys.gameScheduleTime.rawValue] as? Int64 ?? 0
        self.lastActivityTime = json[CodingKeys.lastActivityTime.rawValue] as? Int64 ?? 0
        self.gameEnded = json[CodingKeys.gameEnded.rawValue] as? Bool ?? false
        self.gameStarted = json[CodingKeys.gameStarted.rawValue] as? Bool ?? false
        self.totalPlayersJoined =  json[CodingKeys.totalPlayersJoined.rawValue] as? Int ?? 0
        self.userList = []
        if let userList = json[CodingKeys.userList.rawValue] as? NSDictionary {
            for (_,valueGet) in userList {
                let valueObj = valueGet as? NSDictionary
                let user = UserMO(with: [:])
                let id = valueObj?["id"] as? String ?? ""
                user.id = id
                user.username = valueObj?["name"] as? String ?? ""
                user.fcmToken = valueObj?["fcmToken"] as? String ?? ""
                self.userList?.append(user)
            }
        }
        
        if (self.gameScheduleTime ?? 0) == 0 {
            
        }else {
            self.gameScheduleDate = Utility.convert(TimeInterval((self.gameScheduleTime ?? 0)/1000))
        }
    }
}
