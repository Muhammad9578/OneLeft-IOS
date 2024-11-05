//
//  PlayersLounge2ViewController.swift
//  QuizApp
//
//  Created by user on 08/10/2021.
//

import UIKit
import FirebaseDatabase

class PlayersLounge2ViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startGameBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    
    var room: RoomMO?
    var user = SharedManager.shared.user
    var isLeft = false
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    func setUpView() {
        timerLbl.text = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: playersLoungeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: playersLoungeTableViewCell.identifier)
        reloadJoinedRoom()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadJoinedRoom), name: .loadSecondGameRooms, object: nil)
    }
    
    @objc func reloadJoinedRoom() {
        if isSecondGameRoomLoaded {
            if !isLeft {
                self.room = nil
                for room in allSecondGameRooms {
                    if room.status == "active", !(room.gameStarted ?? false) {
                        self.room = room
                        break
                    }
                }
                var date = Date()
                let minutes = date.minutes
                if minutes < 15 {
                    date = date.adding(minutes: (15 - minutes))
                }else
                if minutes < 30 {
                    date = date.adding(minutes: 30 - minutes)
                }else
                if minutes < 45 {
                    date = date.adding(minutes: (45 - minutes))
                }else
                if minutes < 60 {
                    date = date.adding(minutes: (60 - minutes))
                }
                if let room = self.room {
                    let ref: DatabaseReference?
                    ref = Database.database().reference()
                    if let userList = room.userList {
                        let lists = userList
                        var data = httpParameters()
                        var isUserExists = false
                        
                        for userGet in lists {
                            if (userGet.id ?? "") == (user?.id ?? "") {
                                isUserExists = true
                                break
                            }
                        }
                        
                        if !isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate < Date() {
                            Router.standard.showPayPopUpViewController(from: self, delegate: self, index: 1)
                            //                        data = [
                            //                            "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000),
                            //                            "lastActivityTime": Int64(Date().timeIntervalSince1970 * 1000),
                            //                            "totalPlayersJoined": lists.count + 1
                            //                        ]
                            //                        ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                            //                        let userGet = [
                            //                            "id": user?.id ?? "",
                            //                            "name": user?.username ?? "",
                            //                            "fcmToken": SharedManager.shared.deviceToken ?? ""
                            //                        ]
                            //                        ref?.child(Strings.rooms2).child(room.id ?? "").child("userList").child(user?.id ?? "").updateChildValues(userGet)
                        }else if isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate < Date() {
                            data = [
                                "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000)
                            ]
                            ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                        }else if !isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate > Date() {
                            Router.standard.showPayPopUpViewController(from: self, delegate: self, index: 1)
                            //                        data = [
                            //                            "lastActivityTime": Int64(Date().timeIntervalSince1970 * 1000)
                            //                        ]
                            //                        ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                            //                        let userGet = [
                            //                            "id": user?.id ?? "",
                            //                            "name": user?.username ?? "",
                            //                            "fcmToken": SharedManager.shared.deviceToken ?? ""
                            //                        ]
                            //                        ref?.child(Strings.rooms2).child(room.id ?? "").child("userList").child(user?.id ?? "").updateChildValues(userGet)
                        }else {
                            DispatchQueue.main.async {
                                self.timer?.invalidate()
                                self.timer = nil
                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.reloadTimer), userInfo: nil, repeats: true)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }else {
                    Router.standard.showPayPopUpViewController(from: self, delegate: self, index: 1)
                    //                let ref: DatabaseReference?
                    //                ref = Database.database().reference().child(Strings.rooms2).childByAutoId()
                    //                let key = ref?.key ?? ""
                    //                let userGet = [
                    //                    "id": user?.id ?? "",
                    //                    "name": user?.username ?? "",
                    //                    "fcmToken": SharedManager.shared.deviceToken ?? ""
                    //                ]
                    //                let data: httpParameters = [
                    //                    "id": key,
                    //                    "status": "active",
                    //                    "userList": [(user?.id ?? ""): userGet],
                    //                    "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000),
                    //                    "creationTime": Int64(Date().timeIntervalSince1970 * 1000),
                    //                    "gameEnded": false,
                    //                    "gameStarted": false,
                    //                    "totalPlayersJoined": 1
                    //                ]
                    //                ref?.setValue(data, withCompletionBlock: { error, dataRef in
                    //                    if let error = error {
                    //                        self.showMessage(Strings.error, message: error.localizedDescription, handler: nil)
                    //                    }else {
                    //
                    //                    }
                    //                })
                }
            }
        }
    }
    
    @objc func reloadTimer() {
        let date = Date()
        if let scheduleDate = self.room?.gameScheduleDate {
            let remainingTotalSeconds = Int(scheduleDate.timeIntervalSince(date))
            let remainingMinutes = remainingTotalSeconds / 60
            let remainingSeconds = remainingTotalSeconds % 60
            var remainingMinutesStr = ""
            var remainingSecondsStr = ""
            if remainingMinutes < 10 {
                remainingMinutesStr = "0\(remainingMinutes)"
            }else {
                remainingMinutesStr = "\(remainingMinutes)"
            }
            if remainingSeconds < 10 {
                remainingSecondsStr = "0\(remainingSeconds)"
            }else {
                remainingSecondsStr = "\(remainingSeconds)"
            }
            timerLbl.text = "00 : \(remainingMinutesStr) : \(remainingSecondsStr)"
            print(remainingMinutes)
            print(remainingSeconds)
            if remainingMinutes == 0, remainingSeconds == 10 {
                let data = [
                    "notification": true
                ]
                let ref: DatabaseReference?
                ref = Database.database().reference()
                ref?.child(Strings.rooms2).child(room?.id ?? "").updateChildValues(data)
            }
            if remainingMinutes <= 0, remainingSeconds <= 0, let room = room, (room.userList ?? []).count >= 2 {
                isLeft = true
                timer?.invalidate()
                timer =  nil
                updateStartTime()
                Router.standard.navigateToQuestionnaireViewController(from: navigationController, room: room, game: "game2")
            }
            else if remainingMinutes <= 0, remainingSeconds <= 0, let room = room, (room.userList ?? []).count < 2 {
                timer?.invalidate()
                timer = nil
                var scheduleDate = Date()
                let addMinutes = scheduleDate.minutes
                if addMinutes < 15 {
                    scheduleDate = scheduleDate.adding(minutes: (15 - addMinutes))
                }else
                if addMinutes < 30 {
                    scheduleDate = scheduleDate.adding(minutes: 30 - addMinutes)
                }else
                if addMinutes < 45 {
                    scheduleDate = scheduleDate.adding(minutes: (45 - addMinutes))
                }else
                if addMinutes < 60 {
                    scheduleDate = scheduleDate.adding(minutes: (60 - addMinutes))
                }
                let data = [
                    "gameScheduleTime": Int64(scheduleDate.timeIntervalSince1970 * 1000)
                ]
                let ref: DatabaseReference?
                ref = Database.database().reference()
                ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
            }
        }
    }
    
    @IBAction func startGameTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}

extension PlayersLounge2ViewController: UITableViewDelegate, UITableViewDataSource {
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

extension PlayersLounge2ViewController: PaymentPopDelegate {
    func payClicked() {
        updateFirData()
    }
    
    func errorComes() {
        updateFirData()
    }
    
    func updateFirData() {
        var date = Date()
        let minutes = date.minutes
        if minutes < 15 {
            date = date.adding(minutes: (15 - minutes))
        }else
        if minutes < 30 {
            date = date.adding(minutes: 30 - minutes)
        }else
        if minutes < 45 {
            date = date.adding(minutes: (45 - minutes))
        }else
        if minutes < 60 {
            date = date.adding(minutes: (60 - minutes))
        }
        if let room = self.room {
            let ref: DatabaseReference?
            ref = Database.database().reference()
            if let userList = room.userList {
                let lists = userList
                var data = httpParameters()
                var isUserExists = false
                
                for userGet in lists {
                    if (userGet.id ?? "") == (user?.id ?? "") {
                        isUserExists = true
                        break
                    }
                }
                
                if !isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate < Date() {
                    let userGet = [
                        "id": user?.id ?? "",
                        "name": user?.username ?? "",
                        "fcmToken": SharedManager.shared.deviceToken ?? ""
                    ]
                    ref?.child(Strings.rooms2).child(room.id ?? "").child("userList").child(user?.id ?? "").updateChildValues(userGet)
                    data = [
                        "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000),
                        "lastActivityTime": Int64(Date().timeIntervalSince1970 * 1000),
                        "totalPlayersJoined": (room.totalPlayersJoined ?? 0) + 1
                    ]
                    ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                    
                    updateHistory(key: room.id ?? "")
                }else if isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate < Date() {
                    data = [
                        "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000)
                    ]
                    ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                }else if !isUserExists, let gameScheduleDate = room.gameScheduleDate, gameScheduleDate > Date() {
                    let userGet = [
                        "id": user?.id ?? "",
                        "name": user?.username ?? "",
                        "fcmToken": SharedManager.shared.deviceToken ?? ""
                    ]
                    ref?.child(Strings.rooms2).child(room.id ?? "").child("userList").child(user?.id ?? "").updateChildValues(userGet)
                    data = [
                        "totalPlayersJoined": (room.totalPlayersJoined ?? 0) + 1,
                        "lastActivityTime": Int64(Date().timeIntervalSince1970 * 1000)
                    ]
                    ref?.child(Strings.rooms2).child(room.id ?? "").updateChildValues(data)
                    
                    updateHistory(key: room.id ?? "")
                }else {
                    DispatchQueue.main.async {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.reloadTimer), userInfo: nil, repeats: true)
                    }
                }
            }
            self.tableView.reloadData()
        }else {
            let ref: DatabaseReference?
            ref = Database.database().reference().child(Strings.rooms2).childByAutoId()
            let key = ref?.key ?? ""
            let userGet = [
                "id": user?.id ?? "",
                "name": user?.username ?? "",
                "fcmToken": SharedManager.shared.deviceToken ?? ""
            ]
            let data: httpParameters = [
                "id": key,
                "status": "active",
                "userList": [(user?.id ?? ""): userGet],
                "gameScheduleTime": Int64(date.timeIntervalSince1970 * 1000),
                "creationTime": Int64(Date().timeIntervalSince1970 * 1000),
                "gameEnded": false,
                "gameStarted": false,
                "totalPlayersJoined": 1
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
        let query = Database.database().reference().child(Strings.history).child(self.user?.id ?? "").child(key)
        let data: httpParameters = [
            "dateTime": Int64(Date().timeIntervalSince1970 * 1000),
            "game": "Open Table",
            "id": key,
            "name": self.user?.username ?? "",
            "rewardEarned": 0
        ]
        query.setValue(data) { error, dataRef in
            if let error = error {
                self.showMessage(Strings.error, message: error.localizedDescription)
            }else {
                
            }
        }
    }
    
    func updateStartTime() {
        let data = [
            "gameStarted": true
        ]
        let ref = Database.database().reference()
        ref.child(Strings.rooms2).child(self.room?.id ?? "").updateChildValues(data)
    }
}
