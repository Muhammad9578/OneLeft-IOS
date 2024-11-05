//
//  question2CollectionViewCell.swift
//  4u2nvy
//
//  Created by 123 on 6/2/21.
//

import UIKit
import FirebaseDatabase

protocol optionDelegate {
    func selected(option: String)
}

class question2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var question1Lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: optionDelegate?
    
    var question: QuestionMO? {
        didSet {
            question1Lbl.text = question?.question
            var answers = [String]()
            answers.append(question?.option1 ?? "")
            answers.append(question?.option2 ?? "")
            answers.append(question?.option3 ?? "")
            answers.append(question?.option4 ?? "")
            answersData = answers
            var questions = [String]()
            questions.append(question?.question ?? "")
            questionsText = questions
        }
    }
    var room: RoomMO?
    
    var questionsText: [String]? {
        didSet {
            if (questionsText?.count ?? 0) > 0 {
                if let question1 = questionsText?[0] {
                    question1Lbl.text = question1
                }
            }
        }
    }
    
    var answersData: [String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var selectedIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: questionSelectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: questionSelectTableViewCell.identifier)
    }

}
extension question2CollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: questionSelectTableViewCell.identifier) as! questionSelectTableViewCell
        cell.titleLbl.text = answersData?[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.selectedUnSelectedImage.image = #imageLiteral(resourceName: "selected")
        }else {
            cell.selectedUnSelectedImage.image = #imageLiteral(resourceName: "un-selected")
        }
        cell.titleLbl.text = answersData?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
//        let ref: DatabaseReference?
//        ref = Database.database().reference()
        var choosedOption = ""
        if indexPath.row == 0 {
            choosedOption = "option1"
        }else if indexPath.row == 1 {
            choosedOption = "option2"
        }else if indexPath.row == 2 {
            choosedOption = "option3"
        }else if indexPath.row == 3 {
            choosedOption = "option4"
        }
        delegate?.selected(option: choosedOption)
//        let data: httpParameters = [
//            "correctOption": question?.correct_answer ?? "",
//            "questionId": question?.questionId ?? "",
//            "selectedOption": choosedOption
//        ]
//        ref?.child(Strings.answers).child(room?.id ?? "").child(SharedManager.shared.user?.id ?? "").child(question?.questionId ?? "").updateChildValues(data)
    }
    
}
