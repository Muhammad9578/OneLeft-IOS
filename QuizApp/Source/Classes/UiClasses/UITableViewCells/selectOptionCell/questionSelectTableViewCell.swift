//
//  questionSelectTableViewCell.swift
//  4u2nvy
//
//  Created by 123 on 6/2/21.
//

import UIKit

class questionSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedUnSelectedImage: UIImageView!
    //    @IBOutlet weak var othersTextField: UITextField!
//    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var backView: UIView!
    
//    var index: Int? {
//        didSet {
//            if index == 9 {
//                othersTextField.text = question?.ethnicity ?? ""
//            }else if index == 10 {
//                othersTextField.text = question?.religious ?? ""
//            }else if index == 12 {
//                othersTextField.text = question?.mutipleOtherOption ?? ""
//            }
//        }
//    }
    
//    var question: QuestionMO?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        othersTextField.addTarget(self, action: #selector(change(_:)), for: .editingChanged)
    }
    
//    @objc func change(_ textField: UITextField) {
//        if (textField.text ?? "").trim.isEmpty {
//            if index == 9 {
//                question?.ethnicity = nil
//            }else if index == 10 {
//                question?.religious = nil
//            }else if index == 12 {
//                question?.mutipleOtherOption = nil
//            }
//        }else {
//            if index == 9 {
//                question?.ethnicity = textField.text ?? ""
//            }else if index == 10 {
//                question?.religious = textField.text ?? ""
//            }else if index == 12 {
//                question?.mutipleOtherOption = textField.text ?? ""
//            }
//        }
//    }
}
