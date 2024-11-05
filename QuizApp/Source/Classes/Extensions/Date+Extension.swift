//
//  Date+Extension.swift
//  QuizApp
//
//  Created by user on 09/10/2021.
//

import Foundation

extension Date {
    func getDates(forLastNDays nDays: Int, value: Int) -> [Date] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [Date]()

        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: value, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            arrDates.append(date)
        }
        return arrDates
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }
    var seconds: Int {
        return Calendar.current.component(.second, from: self)
    }
    var hours: Int {
        return Calendar.current.component(.hour, from: self)
    }
    func near(days: Int) -> [Int] {
        return days == 0 ? [day] : (1...abs(days)).map {
            print(adding(days: $0 * (days < 0 ? -1 : 1) ).month)
            return adding(days: $0 * (days < 0 ? -1 : 1) ).day
        }
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
}
