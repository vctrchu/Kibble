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
            notificationTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notificationTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.adjusted),
        ])
        self.view.addSubview(notificationTitle)

        timePickerView.datePickerMode = .time
        timePickerView.setValue(UIColor.white, forKey: "textColor")
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timePickerView.topAnchor.constraint(equalTo: self.notificationTitle.bottomAnchor, constant: 40.adjusted)
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
        noThanksButton.addTarget(self, action: #selector(moveToMealsVC), for: .touchUpInside)
        yesNotifyMeButton.addTarget(self, action: #selector(yesNotifyMePressed), for: .touchUpInside)
    }

    func getTimePickerValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: timePickerView.date)
    }

    @objc func moveToMealsVC() {
        sendData()
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.isMotionEnabled = true
        mealsVC?.motionTransitionType = .fade
        self.present(mealsVC!, animated: true, completion: nil)
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
                    self?.moveToMealsVC()
                }
        }
    }

    func sendData() {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError("Current user uid is nil") }
        let memberData: Dictionary<String, Any> = [uid: true]
        let mealData: Dictionary<String, Any> = ["type": mealType, "isFed": false]
        let notificationData: Dictionary<String, Any> = [getTimePickerValue(): true]
        DataService.instance.addPetToUser(for: uid, with: petId)
        DataService.instance.updateUser(uid: uid, userData: ["currentPet": petId])
        DataService.instance.updatePetMembers(with: petId, and: memberData)
        DataService.instance.updatePetInfo(petId: petId, petData: petData)
        DataService.instance.updatePetMeals(with: petId, with: mealName, and: mealData)
        DataService.instance.updatePetNotifications(with: petId, and: notificationData)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            motionTransitionType = .slide(direction: .right)
            dismiss(animated: true, completion: nil)
        }
    }
}
