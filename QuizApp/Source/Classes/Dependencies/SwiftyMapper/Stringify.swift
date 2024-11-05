//
//  Stringify.swift
//  QuizApp
//
//  Created by user on 9/1/21.
//

import Foundation
protocol Stringify: Encodable {
    var json: String? { get }
}
extension Stringify {
    var json: String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        }
        catch (let err) {
            print(err)
            return nil
        }
    }
}
