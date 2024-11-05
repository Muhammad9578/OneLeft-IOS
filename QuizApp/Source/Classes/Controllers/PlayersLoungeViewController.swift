//
//  PlayersLoungeViewController.swift
//  QuizApp
//
//  Created by user on 01/10/2021.
//

import UIKit
import FirebaseDatabase
import CloudKit

class PlayersLoungeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLbl: UILabel!
    
    var room: RoomMO?
    var user = UserMO(with: [:])
    var timer: Timer?
    var count = -1
    var isLeft = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = SharedManager.shared.user {
            self.user = user
        }
        setUpView()
        timeLbl.isHidden = true
    }
    func setUpView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: playersLoungeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: playersLoungeTableViewCell.identifier)
        reloadJoinedRoom()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadJoinedRoom), name: .loadRooms, object: nil)
    }
    
    @objc func updateData() {
        count -= 1
        timeLbl.isHidden = false
        timeLbl.text = "\(count)"
        if count <= 0 {
            isLeft = true
            count = -1
            timer?.invalidate()
            let data = [
                "gameStarted": true
            ]
            let ref = Database.database().reference()
            ref.child(Strings.rooms).child(self.room?.id ?? "").updateChildValues(data)
            Router.standard.navigateToQuestionnaireViewController(from: navigationController, room: self.room, game: "game1")
        }
    }
    
    @objc func reloadJoinedRoom() {
        if isRoomsLoaded {
            if !isLeft {
                var isJoined = false
                self.room = nil
                for room in allRooms {
                    if let userList = room.userList {
                        for localUser in userList {
                            if (localUser.id ?? "") == (user.id ?? "") {
                                if !(room.gameStarted ?? false) {
                                    isJoined = true
                                    break
                                }
                            }
                        }
                    }
                    if isJoined {
                        self.room = room
                        break
                    }
                }
                
                if isJoined {
                    timer?.invalidate()
                    if let startDate = self.room?.gameScheduleDate {
                        let endDate = Date()
                        count = Int(startDate.timeIntervalSince(endDate))
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
                    }
                    self.tableView.reloadData()
                }else {
                    for room in allRooms {
                        if let userList = room.userList, userList.count < 3, room.status == "active", !(room.gameStarted ?? false) {
                            self.room = room
                            break
                        }
                    }
                    if let _ = self.room {
                        Router.standard.showPayPopUpViewController(from: self, delegate: self, index: 0)
                    }else {
                        Router.standard.showPayPopUpViewController(from: self, delegate: self, index: 0)
                    }
                }
            }
        }else {
            print("no loaded")
        }
        
    }

    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}

extension PlayersLoungeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room?.userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playersLoungeTableViewCell.identifier) as! playersLoungeTableViewCell
        let user = room?.userList?[indexPath.row]
        cell.userNameLbl.text = FirebaseUtility.getDesiredUser(id: user?.id ?? "")?.username ?? ""
        return cell
    }
}

extension PlayersLoungeViewController: PaymentPopDelegate {
    func payClicked() {
        updateFirData()
    }
    
    func errorComes() {
        updateFirData()
    }
    
    func updateFirData() {
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        if let room = self.room {
            let ref: DatabaseReference?
            ref = Database.database().reference()
            let userGet = [
                "id": user.id ?? "",
                "name": user.username ?? "",
                "fcmToken": SharedManager.shared.deviceToken ?? ""
            ]
            let data: httpParameters = [
                "totalPlayersJoined": (room.totalPlayersJoined ?? 0) + 1,
                "lastActivityTime": timeStamp,
            ]
            ref?.child(Strings.rooms).child(room.id ?? "").child("userList").child(user.id ?? "").updateChildValues(userGet)
            ref?.child(Strings.rooms).child(room.id ?? "").updateChildValues(data)
            updateHistory(key: room.id ?? "")
        }else {
            let ref: DatabaseReference?
            ref = Database.database().reference().child(Strings.rooms).childByAutoId()
            let key = ref?.key ?? ""
            let userGet = [
                "id": user.id ?? "",
                "name": user.username ?? "",
                "fcmToken": SharedManager.shared.deviceToken ?? ""
            ]
            let obj = [(user.id ?? ""): userGet]
            let data: httpParameters = [
                "creationTime": timeStamp,
                "gameStarted": false,
                "gameEnded": false,
                "gameScheduleTime": 0,
                "lastActivityTime": timeStamp,
                "totalPlayersJoined": 1,
                "id": key,
                "status": "active",
                "userList": obj
            ]
            ref?.setValue(data, withCompletionBlock: { error, dataRef in
                if let error = error {
                    self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
                }else {
                    self.updateHistory(key: key)
                }
            })
        }
    }
    
    func updateHistory(key: String) {
        let query = Database.database().reference().child(Strings.history).child(self.user.id ?? "").child(key)
        let data1: httpParameters = [
            "dateTime": Int64(Date().timeIntervalSince1970 * 1000),
            "game": "10 - User Table",
            "id": key,
            "name": self.user.username ?? "",
            "rewardEarned": 0
        ]
        query.setValue(data1) { error, dataRef in
            if let error = error {
                self.showMessage(Strings.error, message: error.localizedDescription)
            }else {
                
            }
        }
    }
}
