//
//  HistoryViewController.swift
//  QuizApp
//
//  Created by user on 9/4/21.
//

import UIKit

class HistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var rewards = [RewardMO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.identifier)
        FirebaseUtility.getMyRewards { rewards in
            self.rewards = rewards
            self.tableView.reloadData()
        }
        
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        back()
    }
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as! HistoryTableViewCell
        cell.reward = self.rewards[indexPath.row]
        return cell
    }
}
