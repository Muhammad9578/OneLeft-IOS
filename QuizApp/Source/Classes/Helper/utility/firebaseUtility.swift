//
//  firebaseUtility.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation
import Alamofire
import FirebaseDatabase

typealias ResponseApiCompletion = (_ isSuccess: Bool, _ error: String) -> Void
typealias HttpParameters = [String: Any]
var allUsers = [UserMO]()
var allRooms = [RoomMO]()
var allSecondGameRooms = [RoomMO]()
var isRoomsLoaded = false
var isSecondGameRoomLoaded = false
class FirebaseUtility: NSObject {
    
    static var baseUrl = "https://uppi.androidworkshop.net/"
    static var encoding = URLEncoding.default
    
    static func getAllUsersData() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.users).observe(.value, with: { (snapShot) in
            allUsers = []
            if let data = snapShot.value as? HttpParameters {
                for (_, userValue) in data {
                    let user = UserMO(with: userValue as? HttpParameters ?? [:])
                    allUsers.append(user)
                    if (user.id ?? "") == (SharedManager.shared.user?.id ?? "") {
                        SharedManager.shared.user = user
                    }
                }
                FirebaseUtility.getAllRoomsData()
                FirebaseUtility.getAllSecondGameRoomsData()
                NotificationCenter.default.post(name: .loadUsers, object: nil)
            }else {
                NotificationCenter.default.post(name: .loadUsers, object: nil)
            }
        })
    }
    
    static func getAllRoomsData() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.rooms).observe(.value, with: { (snapShot) in
            allRooms = []
            isRoomsLoaded = true
            if let data = snapShot.value as? HttpParameters {
                for (_, roomValue) in data {
                    let room = RoomMO(with: roomValue as? HttpParameters ?? [:])
                    allRooms.append(room)
                }
                NotificationCenter.default.post(name: .loadRooms, object: nil)
            }else {
                NotificationCenter.default.post(name: .loadRooms, object: nil)
            }
        })
    }
    
    static func getMyRewards(completion: @escaping ([RewardMO]) -> Void) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.history).child(SharedManager.shared.user?.id ?? "").observeSingleEvent(of: .value, with: { snapShot in
            var myRewards = [RewardMO]()
            if let data = snapShot.value as? HttpParameters {
                for (_, rewardValue) in data {
                    let reward = RewardMO(with: rewardValue as? HttpParameters ?? [:])
                    myRewards.append(reward)
                }
                completion(myRewards)
            }else {
                completion(myRewards)
            }
        })
    }
    
    static func getAllSecondGameRoomsData() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.rooms2).observe(.value, with: { (snapShot) in
            allSecondGameRooms = []
            isSecondGameRoomLoaded = true
            if let data = snapShot.value as? HttpParameters {
                for (_, roomValue) in data {
                    let room = RoomMO(with: roomValue as? HttpParameters ?? [:])
                    allSecondGameRooms.append(room)
                }
                NotificationCenter.default.post(name: .loadSecondGameRooms, object: nil)
            }else {
                NotificationCenter.default.post(name: .loadSecondGameRooms, object: nil)
            }
        })
    }
    
    static func getQuestionsData(completion: @escaping ([QuestionMO]) -> Void) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.mcqs).observeSingleEvent(of: .value, with: { (snapShot) in
            var allMcqs = [QuestionMO]()
            if let data = snapShot.value as? HttpParameters, data.count != 0 {
                for category in data {
                    let quesions = category.value as? HttpParameters ?? [:]
                    for (questionKey, questionValue) in quesions {
                        let question = QuestionMO(with: questionValue as? HttpParameters ?? [:])
                        question.questionId = questionKey
                        allMcqs.append(question)
                    }
                    completion(allMcqs)
                }
            }else {
                completion([])
            }
        })
    }
    
    static func getAnswersData(room: RoomMO?, completion: @escaping (RoomMO?) -> Void) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.answers).child(room?.id ?? "").observe(.value, with: { (snapShot) in
            for user in (room?.userList ?? []) {
                user.answers = []
            }
            if let data = snapShot.value as? HttpParameters, data.count != 0 {
                for (userId, answerValue) in data {
                    var answers = [AnswerMO]()
                    let answerObj = answerValue as? httpParameters
                    for (_, answerResult) in (answerObj ?? [:]) {
                        let answer = AnswerMO(with: answerResult as? HttpParameters ?? [:])
                        answers.append(answer)
                    }
                    for user in room?.userList ?? [] {
                        if (user.id ?? "") == userId {
                            user.answers = answers
                        }
                    }
                }
                completion(room)
                
            }else {
                completion(room)
            }
        })
    }
    
   static func getDesiredUser(id: String) -> UserMO? {
        for user in allUsers {
            if user.id == id {
                return user
            }
        }
        
        return nil
    }
    
    static func sendOtp(email: String, completion: @escaping ResponseApiCompletion) {
        let params = [
            "email": email
        ]
        
        print("\(baseUrl)/send_otp.php")
        Alamofire.request("\(baseUrl)send_otp.php", method: .post, parameters: params, encoding: encoding)
            .responseJSON { response in
                print(response.result)
                let result = response.result.value as? NSDictionary ?? [:]
                let code = result["status"] as? Int ?? 0
                let message = result["message"] as? String ?? ""
                if code == 1, message == Strings.email_sent_success {
                    completion(true, message)
                }else {
                    completion(false, message)
                }
            }
    }
    
    static func verifyOtp(email: String, otpNumber: String, completion: @escaping ResponseApiCompletion) {
        let params = [
            "email": email,
            "code": otpNumber
        ]
        Alamofire.request("\(baseUrl)verify_otp.php", method: .post, parameters: params, encoding: encoding)
            .responseJSON { response in
                print(response.result)
                let result = response.result.value as? NSDictionary ?? [:]
                let code = result["status"] as? Int ?? 0
                let message = result["message"] as? String ?? ""
                if code == 1, message == Strings.verify_success {
                    completion(true, message)
                }else {
                    completion(false, message)
                }
            }
    }
}
