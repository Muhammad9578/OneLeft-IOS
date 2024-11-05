//
//  AnswerMO.swift
//  QuizApp
//
//  Created by user on 02/10/2021.
//

import Foundation

class AnswerMO: Mappable, Stringify {
    var correctOption: String?
    var questionId: String?
    var selectedOption: String?
    
    enum CodingKeys: String, CodingKey {
        case correctOption = "correctOption"
        case questionId = "questionId"
        case selectedOption = "selectedOption"
    }
    
    init(with json: [String: Any]) {
        self.correctOption = json[CodingKeys.correctOption.rawValue] as? String ?? ""
        self.questionId = json[CodingKeys.questionId.rawValue] as? String ?? ""
        self.selectedOption = json[CodingKeys.selectedOption.rawValue] as? String ?? ""
    }
}


