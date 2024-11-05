//
//  QuestionnaireViewController.swift
//  QuizApp
//
//  Created by user on 29/09/2021.
//

import UIKit
import FirebaseDatabase

var mcqs = [QuestionMO]()
class QuestionnaireViewController: BaseViewController {

    @IBOutlet weak var rView: UIView!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var questionNoLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var index = 0
    var timer: Timer?
    var questionTimer: Timer?
    var room: RoomMO?
    var count = 0
    var questionCounter = 0
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var isLoaded = false
    var selectedQuestionOption = ""
    var game = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: question2CollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: question2CollectionViewCell.identifier)
        if game == "game1" {
            loadRoom()
            NotificationCenter.default.addObserver(self, selector: #selector(loadRoom), name: .loadRooms, object: nil)
        }else if game == "game2" {
            loadSecondRoom()
            NotificationCenter.default.addObserver(self, selector: #selector(loadSecondRoom), name: .loadSecondGameRooms, object: nil)
        }
        getQuestions()
    }
    
    @objc func loadSecondRoom() {
        for room in allSecondGameRooms {
            if (room.id ?? "") == (self.room?.id ?? "") {
                self.room = room
                break
            }
        }
        let user = SharedManager.shared.user
        if let users = self.room?.userList, users.count == 1 {
            if (user?.id ?? "") == (users[0].id ?? "") {
                self.timer?.invalidate()
                self.timer = nil
                self.questionTimer?.invalidate()
                self.questionTimer = nil
                Router.standard.navigateToGame1ResultsViewController(from: navigationController, room: self.room)
            }
        }
    }
    
    @objc func loadRoom() {
        for room in allRooms {
            if (room.id ?? "") == (self.room?.id ?? "") {
                self.room = room
                break
            }
        }
        let user = SharedManager.shared.user
        if let users = self.room?.userList, users.count == 1 {
            if (user?.id ?? "") == (users[0].id ?? "") {
                self.timer?.invalidate()
                self.timer = nil
                self.questionTimer?.invalidate()
                self.questionTimer = nil
                Router.standard.navigateToGame1ResultsViewController(from: navigationController, room: self.room)
            }
        }
    }
    
    func loadCircle() {
        // let's start by drawing a circle somehow
        
        let center = rView.center
//        center.x = (center.x)
        // create my track layer
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: CGFloat.pi, endAngle: -2 * CGFloat.pi, clockwise: false)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.red.cgColor
        trackLayer.lineWidth = 4
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func handleTimer() {
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 10
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @objc func questionLoad() {
        if questionCounter == 6 {
            if index == (mcqs.count - 1) {
                questionCounter = 0
                questionTimer?.invalidate()
                questionTimer = nil
                rView.isHidden = true
                trackLayer.lineWidth = 0
                shapeLayer.lineWidth = 0
                nextTapped()
            }else {
                questionCounter = 0
                questionTimer?.invalidate()
                questionTimer = nil
                secondLbl.text = "5"
                nextTapped()
            }
        }else {
            secondLbl.text = "\(5 - questionCounter)"
            questionCounter += 1
        }
    }
    
    
    func getQuestions() {
        FirebaseUtility.getQuestionsData { localMcqs in
            mcqs = localMcqs.shuffled()
            self.collectionView.reloadData()
            if !self.isLoaded {
                self.secondLbl.text = "5"
                self.isLoaded = true
                self.loadCircle()
                self.handleTimer()
                self.questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.questionLoad), userInfo: nil, repeats: true)
            }
        }
    }
    
    @IBAction func leaveQuestionsTapped(_ sender: Any) {
        self.showContinueAlert(Strings.confirmation, message: Strings.sureWantLeave, continueHandler: { _ in
            self.removeUserFromRoom()
            Router.standard.navigateBackToHomeOrPlatform(from: self.navigationController)
        }, cancelHandler: nil, continueTitle: "Yes", cancelTitle: "No")
    }
    
    func removeUserFromRoom() {
        let ref = Database.database().reference()
        let user = SharedManager.shared.user
        var room = ""
        if game == "game1" {
            room = Strings.rooms
        }else if game == "game2" {
            room = Strings.rooms2
        }
        ref.child(room).child(self.room?.id ?? "").child("userList").child(user?.id ?? "").removeValue()
    }
    
    
    @IBAction func nextQuestionTapped(_ sender: Any) {
//        nextTapped()
    }
    
    func nextTapped() {
        if selectedQuestionOption.isEmpty {
            removeUserFromRoom()
            Router.standard.showOutOfGameViewController(from: self, delegate: self, noAnswer: true)
        }else {
            let question = mcqs[index]
            if index == (mcqs.count - 1) {
                if question.correct_answer == selectedQuestionOption {
                    timer?.invalidate()
                    timer = nil
                    Router.standard.navigateToGame1ResultsViewController(from: navigationController, room: room)
                }else {
                    removeUserFromRoom()
                    Router.standard.showOutOfGameViewController(from: self, delegate: self, noAnswer: false)
                }
            }else {
                if question.correct_answer == selectedQuestionOption {
                    selectedQuestionOption = ""
                    questionCounter = 0
                    questionTimer?.invalidate()
                    questionTimer = nil
                    self.collectionView.isScrollEnabled = true
                    let collectionBounds = self.collectionView.bounds
                    let contentOffset = CGFloat(floor(self.collectionView.contentOffset.y + collectionBounds.size.height))
                    self.moveCollectionToFrame(contentOffset: contentOffset)
                    index += 1
                }else {
                    removeUserFromRoom()
                    Router.standard.showOutOfGameViewController(from: self, delegate: self, noAnswer: false)
                }
            }
        }
    }
    
    
    @objc func repeatTimer() {
        if count == 1 {
            timer?.invalidate()
            count = 0
            questionNoLbl.text = "\(index + 1)"
            if index == (mcqs.count - 1) {
                questionCounter = 0
                questionTimer?.invalidate()
                questionTimer = nil
                handleTimer()
                questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(questionLoad), userInfo: nil, repeats: true)
//                nextBtn.setTitle("Finish", for: .normal)
            }else {
                questionCounter = 0
                questionTimer?.invalidate()
                questionTimer = nil
//                nextBtn.setTitle("Next", for: .normal)
                handleTimer()
                questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(questionLoad), userInfo: nil, repeats: true)
            }
//            did(enable: true)
//            previousBtn.isEnabled = index != 0
        }else {
            count += 1
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : self.collectionView.contentOffset.x ,y : contentOffset ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
        self.collectionView.isScrollEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(repeatTimer), userInfo: nil, repeats: true)
    }

    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}

extension QuestionnaireViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mcqs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: question2CollectionViewCell.identifier, for: indexPath) as! question2CollectionViewCell
        cell.room = room
        cell.question = mcqs[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension QuestionnaireViewController: optionDelegate {
    func selected(option: String) {
        selectedQuestionOption = option
    }
}

extension QuestionnaireViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let boundHeight = bounds.height
        let width = bounds.width
        return CGSize(width: width, height: boundHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension QuestionnaireViewController: OutOfGameDelegate {
    func leaveGame() {
        Router.standard.navigateBackToHomeOrPlatform(from: navigationController)
    }
}
