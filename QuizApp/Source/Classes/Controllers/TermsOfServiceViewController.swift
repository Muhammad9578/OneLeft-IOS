//
//  TermsOfServiceViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import PDFKit

class TermsOfServiceViewController: BaseViewController {

    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var isAgreeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var isNewUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewUser {
            backBtn.isHidden = true
            isAgreeBtn.isHidden = false
        }else {
            backBtn.isHidden = false
            isAgreeBtn.isHidden = true
        }
        
        if let path = Bundle.main.path(forResource: "terms_conditions", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
    }
    
    @IBAction func iAgreeTapped(_ sender: Any) {
        Router.standard.navigateToHomeViewController(from: self.navigationController)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        back()
    }
    
}
