//
//  mealsVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-14.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class AllowNotificationsVC: UIViewController {

    @IBOutlet weak var notificationTitle: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBOutlet weak var yesNotifyMeButton: UIButton!
    @IBOutlet weak var timePickerView: UIDatePicker!

    var petId = ""
    var petData = Dictionary<String,Any>()
    var mealName = ""
    var mealType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonFunctionality()
    }

    override func loadView() {
        super.loadView()
        notificationTitle.translatesAutoresizingMaskIntoConstraints = false
        notificationTitle.contentMode = UIView.ContentMode.scaleAspectFill
        NSLayoutConstraint.activate([
            notificationTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.adjusted),
        ])
        self.view.addSubview(notificationTitle)

        timePickerView.datePickerMode = .time
        timePickerView.setValue(UIColor.white, forKey: "textColor")
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePickerView.topAnchor.constraint(equalTo: notificationTitle.bottomAnchor, constant: 40.adjusted)
        ])
        self.view.addSubview(timePickerView)

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 40.adjusted),
            buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        self.view.addSubview(buttonStackView)

    }

    func addButtonFunctionality() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        noThanksButton.addTarget(self, action: #selector(noThanksPressed), for: .touchUpInside)
        yesNotifyMeButton.addTarget(self, action: #selector(yesNotifyMePressed), for: .touchUpInside)
    }

    func getTimePickerValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: timePickerView.date)
    }

    @objc func noThanksPressed() {
        sendData(withNotification: false)
    }

    @objc func yesNotifyMePressed(_ button: UIButton) {
        print("\(getTimePickerValue())")
        // Implement after tablview meals is working
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                print("Permission granted: \(granted)")
                // 1. Check if permission granted
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    self?.sendData(withNotification: true)
                }
        }
    }

    func moveToMealsVC() {
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.isMotionEnabled = true
        mealsVC?.motionTransitionType = .fade
        self.present(mealsVC!, animated: true, completion: nil)
    }

    func sendData(withNotification notification: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError("Current user uid is nil") }
        DataService.instance.retrieveUserFullName(withUid: uid) { (name) in
            let memberData: Dictionary<String, Any> = [uid: name]
            DataService.instance.updatePetMembers(withPetId: self.petId, andMemberData: memberData)
        }
        let mealData: Dictionary<String, Any> = ["type": mealType, "isFed": "false"]
        let notificationData: Dictionary<String, Any> = ["notification" : getTimePickerValue()]

        DataService.instance.addPetToUser(forUid: uid, withPetId: petId)
        DataService.instance.updateUser(withUid: uid, withUserData: ["currentPet": petId])
        DataService.instance.createPetInfo(withPetId: petId, andPetData: petData)
        
        DataService.instance.updateDefaultPetMeals(withPetId: petId, withMealName: mealName, andMealData: mealData) {
            DataService.instance.updateDefaultPetMealNotifications(withPetId: self.petId, withMealName: self.mealName, andNotificationData: notificationData) {}
        }
        DataService.instance.updatePetMeals(withPetId: petId, withMealName: mealName, andMealData: mealData) {}
        if notification {
            DataService.instance.updatePetMealNotifications(withPetId: petId, withMealName: mealName, andNotificationData: notificationData) {
                self.moveToMealsVC()
            }
        } else {
            moveToMealsVC()
        }
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            motionTransitionType = .slide(direction: .right)
            dismiss(animated: true, completion: nil)
        }
    }
}
