//
//  NSNotification+Extension.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation
extension Notification.Name {
    static let loadRooms = Notification.Name("loadRooms")
    static let loadSecondGameRooms = Notification.Name("loadSecondGameRooms")
    static let loadMyData = Notification.Name("loadMyData")
    static let loadUsers = Notification.Name("loadUsers")
    static let loadQuestions = Notification.Name("loadQuestions")
    static let loadVideos = Notification.Name("loadVideos")

}
