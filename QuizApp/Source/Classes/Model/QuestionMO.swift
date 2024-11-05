//
//  QuestionMO.swift
//  QuizApp
//
//  Created by user on 02/10/2021.
//

import Foundation

class QuestionMO: Mappable, Stringify {
    var category_id: String?
    var questionId: String?
    var correct_answer: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var option4: String?
    var question: String?
    
    enum CodingKeys: String, CodingKey {
        case category_id = "category_id"
        case correct_answer = "correct_answer"
        case option1 = "option1"
        case option2 = "option2"
        case option3 = "option3"
        case option4 = "option4"
        case question = "question"
    }
    
    init(with json: [String: Any]) {
        self.category_id = json[CodingKeys.category_id.rawValue] as? String ?? ""
        self.correct_answer = json[CodingKeys.correct_answer.rawValue] as? String ?? ""
        self.option1 = json[CodingKeys.option1.rawValue] as? String ?? ""
        self.option2 = json[CodingKeys.option2.rawValue] as? String ?? ""
        self.option3 = json[CodingKeys.option3.rawValue] as? String ?? ""
        self.option4 = json[CodingKeys.option4.rawValue] as? String ?? ""
        self.question = json[CodingKeys.question.rawValue] as? String ?? ""
    }
}

