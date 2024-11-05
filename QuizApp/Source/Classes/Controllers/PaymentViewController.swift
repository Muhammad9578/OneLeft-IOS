//
//  PaymentViewController.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit

class PaymentViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PaymentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PaymentTableViewCell.identifier)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        back()
    }
    
}
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier) as! PaymentTableViewCell
        
                     return cell
    }
    
    
}
