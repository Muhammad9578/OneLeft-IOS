//
//  Utility.swift
//  QuizApp
//
//  Created by user on 25/09/2021.
//

import Foundation
import NVActivityIndicatorView

class Utility: NSObject {
    static func startLoader() {
        let activityData = ActivityData(size: CGSize(width: 60, height: 60), message: "", messageFont: UIFont.boldSystemFont(ofSize: 20), messageSpacing: 0.0, type: .ballClipRotate, color: #colorLiteral(red: 0.5991255641, green: 0.1120380238, blue: 0.06627932936, alpha: 1), padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: .none, textColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    static func stopLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    static func convert(_ timeStamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeStamp)
    }
    
    static func getReadableDate(timeStamp: TimeInterval) -> String? {
        let timeStampGet = Double(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            dateFormatter.dateFormat = "h:mm a"
            return "Tomorrow \(dateFormatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return "Yesterday \(dateFormatter.string(from: date))"
        } else if dateFallsInWeek(timeStamp: timeStampGet, date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return "\(dateFormatter.string(from: date))"
            } else {
                dateFormatter.dateFormat = "EEEE h:mm a"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy  h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    
    static func dateFallsInWeek(timeStamp: Double, date: Date) -> Bool {
        let pastSevenDays = date.getDates(forLastNDays: 7, value: -1)
        let lastTimeStamp = Double(pastSevenDays.last?.timeIntervalSince1970 ?? 0.0)
        if timeStamp > lastTimeStamp {
            return true
        }else {
            return false
        }
    }
}
