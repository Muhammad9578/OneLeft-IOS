//
//  Game1ResultsViewController.swift
//  QuizApp
//
//  Created by user on 02/10/2021.
//

import UIKit
import Alamofire
import FirebaseDatabase

class Game1ResultsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var room: RoomMO?
    var reward = 0.0
    var game = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        if game == "game1" {
            loadRoom()
            NotificationCenter.default.addObserver(self, selector: #selector(loadRoom), name: .loadRooms, object: nil)
        }else if game == "game2" {
            loadSecondRoom()
            NotificationCenter.default.addObserver(self, selector: #selector(loadSecondRoom), name: .loadSecondGameRooms, object: nil)
        }
    }
    
    @objc func loadSecondRoom() {
        for room in allSecondGameRooms {
            if (room.id ?? "") == (self.room?.id ?? "") {
                self.room = room
                break
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func loadRoom() {
        for room in allRooms {
            if (room.id ?? "") == (self.room?.id ?? "") {
                self.room = room
                break
            }
        }
        self.tableView.reloadData()
    }
    
    func setUpView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: game1ResultTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: game1ResultTableViewCell.identifier)
        let reward = Double(room?.totalPlayersJoined ?? 0) * 0.99
        let percantageOfTotal = (reward * 75) / 100
        self.reward = percantageOfTotal / Double(self.room?.userList?.count ?? 0)
        self.tableView.reloadData()
    }
    
    @IBAction func claimRewardTapped(_ sender: Any) {
        if let account_id = UserDefaults.standard.string(forKey: Strings.account_id), !account_id.isEmpty {
            let encoding = URLEncoding.default
            reward = reward * 100
            let params: httpParameters = [
                "account_id": account_id,
                "amount": "\(reward)"
            ]
            let request = Alamofire.request("https://uppi.androidworkshop.net/stripe_api.php?action=claim_reward", method: .post, parameters: params, encoding: encoding, headers: [:])
            Utility.startLoader()
            handleJSONResponse(for: request) { result, error in
                Utility.stopLoader()
//                do {
                    if let _ = result {
//                        let json = try JSONSerialization.jsonObject(with: result, options: []) as? [String : Any]
                        self.updateReward(key: self.room?.id ?? "")
                        self.showMessage(Strings.success, message: "You amount $\(self.reward) claimed successfully.") { _ in
                            Router.standard.navigateBackToHomeOrPlatform(from: self.navigationController)
                        }
                    }else if let _ = error {
                        self.showMessage(Strings.error, message: "You need to setup your full account.") { _ in
                            Router.standard.navigateToSetupStripeViewController(from: self.navigationController)
                        }
                    }
//                }
//                catch let error
//                {
//                    self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
//                }
            }
        }else {
            Router.standard.navigateToSetupStripeViewController(from: navigationController)
        }
    }
    
    func updateReward(key: String) {
        let user = SharedManager.shared.user
        let query = Database.database().reference().child(Strings.history).child(user?.id ?? "").child(key)
        let data1: httpParameters = [
            "rewardEarned": reward
        ]
        query.setValue(data1) { error, dataRef in
            if let error = error {
                self.showMessage(Strings.error, message: error.localizedDescription)
            }else {
                
            }
        }
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        Router.standard.navigateBackToHomeOrPlatform(from: navigationController)
    }
    

}

extension Game1ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: game1ResultTableViewCell.identifier) as! game1ResultTableViewCell
        if let user = FirebaseUtility.getDesiredUser(id: room?.userList?[indexPath.row].id ?? "") {
            cell.userNameLbl.text = user.username ?? ""
        }
        cell.attemptedQuestionsLbl.text = "Correct Answers: \(mcqs.count)"
        cell.rewardLbl.text = "Reward: $\(self.reward)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room?.userList?.count ?? 0
    }
}
