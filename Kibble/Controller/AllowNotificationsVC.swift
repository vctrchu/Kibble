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
import Pastel

class AllowNotificationsVC: UIViewController {

    // MARK: - Properties

    @IBOutlet var pastelView: PastelView!
    @IBOutlet weak var notificationTitle: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBOutlet weak var yesNotifyMeButton: UIButton!
    @IBOutlet weak var timePickerView: UIDatePicker!

    private var petId = ""
    private var petData = Dictionary<String,Any>()
    private var mealName = ""
    private var mealType = ""

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonFunctionality()

    }

    override func viewDidAppear(_ animated: Bool) {
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3
        pastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1),#colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.9019607843, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1)])
        pastelView.startAnimation()
        notificationTitle.fadeIn(duration: 1, delay: 0) { (Bool) in
            self.timePickerView.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                self.buttonStackView.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                }
            }
        }
    }

    override func loadView() {
        super.loadView()

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)]
        gradientLayer.frame = view.bounds
        pastelView.layer.insertSublayer(gradientLayer, at: 0)

        notificationTitle.translatesAutoresizingMaskIntoConstraints = false
        notificationTitle.contentMode = UIView.ContentMode.scaleAspectFill
        notificationTitle.alpha = 0
        NSLayoutConstraint.activate([
            notificationTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.adjusted),
        ])
        self.view.addSubview(notificationTitle)

        timePickerView.datePickerMode = .time
        timePickerView.setValue(UIColor.white, forKey: "textColor")
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        timePickerView.alpha = 0
        NSLayoutConstraint.activate([
            timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePickerView.topAnchor.constraint(equalTo: notificationTitle.bottomAnchor, constant: 40.adjusted)
        ])
        self.view.addSubview(timePickerView)

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.alpha = 0
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 40.adjusted),
            buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        self.view.addSubview(buttonStackView)

    }

    func setupVariables(petId: String, petData: [String:Any], mealName: String, mealType: String) {
        self.petId = petId
        self.petData = petData
        self.mealName = mealName
        self.mealType = mealType
    }

    // MARK: - Add Target Methods

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            motionTransitionType = .slide(direction: .right)
            dismiss(animated: true, completion: nil)
        }
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

    // MARK: - Move to next VC Methods

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

    func getTimePickerValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: timePickerView.date)
    }

    func addButtonFunctionality() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        noThanksButton.addTarget(self, action: #selector(noThanksPressed), for: .touchUpInside)
        yesNotifyMeButton.addTarget(self, action: #selector(yesNotifyMePressed), for: .touchUpInside)
    }
}
