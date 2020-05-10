//
//  AddMealVCViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-24.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

protocol AddMealDelegate {
    func refreshTableView()
}

@available(iOS 13.0, *)
class AddMealVC: UIViewController {

    //MARK: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addMealTitle: UIImageView!
    @IBOutlet weak var mealNameTextField: UITextField! {
        didSet {
            mealNameTextField.tintColor = UIColor.gray
            mealNameTextField.setIcon(#imageLiteral(resourceName: "MealNameIcon"))
        }
    }
    @IBOutlet weak var typeFoodStackView: UIStackView!
    @IBOutlet weak var typeOfFoodTitle: UIImageView!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dryButton: UIButton!
    @IBOutlet weak var wetButton: UIButton!
    @IBOutlet weak var treatButton: UIButton!
    @IBOutlet weak var turnOffNotifications: UIButton!

    private var mealType: String?
    private var reminderTime: String?
    var delegate: AddMealDelegate?

    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        addGenstures()
    }

    //MARK: - Auto Constraints

    override func loadView() {
        super.loadView()
        view.addSubview(cancelButton)
        view.addSubview(addMealTitle)
        view.addSubview(mealNameTextField)
        view.addSubview(typeFoodStackView)
        view.addSubview(typeOfFoodTitle)
        view.addSubview(addReminderButton)
        view.addSubview(turnOffNotifications)
        view.addSubview(saveButton)

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        addMealTitle.translatesAutoresizingMaskIntoConstraints = false
        addMealTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            addMealTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.adjusted),
            addMealTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        mealNameTextField.translatesAutoresizingMaskIntoConstraints = false
        mealNameTextField.contentMode = UIView.ContentMode.scaleAspectFit
        mealNameTextField.layer.backgroundColor = UIColor.white.cgColor
        mealNameTextField.placeholder = "meal name"
        mealNameTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        mealNameTextField.layer.cornerRadius = 10
        mealNameTextField.clipsToBounds = true
        mealNameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        NSLayoutConstraint.activate([
            mealNameTextField.topAnchor.constraint(equalTo: addMealTitle.bottomAnchor, constant: 20.adjusted),
            mealNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealNameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            mealNameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted)
        ])

        typeOfFoodTitle.translatesAutoresizingMaskIntoConstraints = false
        typeOfFoodTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeOfFoodTitle.topAnchor.constraint(equalTo: mealNameTextField.bottomAnchor, constant: 20.adjusted),
            typeOfFoodTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        typeFoodStackView.translatesAutoresizingMaskIntoConstraints = false
        typeFoodStackView.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeFoodStackView.topAnchor.constraint(equalTo: typeOfFoodTitle.bottomAnchor, constant: 20.adjusted),
            typeFoodStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        addReminderButton.translatesAutoresizingMaskIntoConstraints = false
        addReminderButton.setTitle("Add Reminder", for: .normal)
        addReminderButton.setTitleColor(UIColor.white, for: .normal)
        addReminderButton.addTarget(self, action: #selector(addReminderPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addReminderButton.topAnchor.constraint(equalTo: typeFoodStackView.bottomAnchor, constant: 20.adjusted),
            addReminderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        turnOffNotifications.translatesAutoresizingMaskIntoConstraints = false
        turnOffNotifications.setTitle("Turn off notifications", for: .normal)
        turnOffNotifications.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        turnOffNotifications.addTarget(self, action: #selector(turnOffNotificationsPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            turnOffNotifications.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: 20.adjusted),
            turnOffNotifications.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: turnOffNotifications.bottomAnchor, constant: 20.adjusted),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    //MARK: - Add Target Methods

    @objc func addReminderPressed() {
        let addReminderVC = self.storyboard?.instantiateViewController(identifier: "AddReminderVC") as! AddReminderVC
        addReminderVC.delegate = self
        self.present(addReminderVC, animated: true, completion: nil)
    }

    @objc func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonPressed() {
        if mealNameTextField.text?.isReallyEmpty ?? true ||
            !(dryButton.isSelected || wetButton.isSelected || treatButton.isSelected){
            saveButton.shake()
        } else {
            if (reminderTime == nil) {
                let alert = UIAlertController(title: "Add a Reminder?",
                                              message: "Did you forget to add a reminder?",
                                              preferredStyle: UIAlertController.Style.alert)

                let noThanksAction = UIAlertAction(title: "No Thanks", style: .default) { _ in
                    self.dismissVC()
                }
                alert.addAction(noThanksAction)

                let addAction = UIAlertAction(title: "Add", style: .default) { _ in
                    self.addReminderPressed()
                }
                alert.addAction(addAction)
                alert.preferredAction = addAction
                self.present(alert, animated: true, completion: nil)
            } else {
                dismissVC()
            }
        }
    }

    @objc func turnOffNotificationsPressed() {
        reminderTime = "none"
        addReminderButton.setTitle("Add Reminder", for: .normal)
    }

    func dismissVC() {
        let mealName = mealNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let mealData = ["isFed": "false", "type": mealType]
        let notificationData: Dictionary<String, Any> = ["notification" : reminderTime]
        DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
            DataService.instance.updatePetMeals(withPetId: petId! , withMealName: mealName, andMealData: mealData) {}
            DataService.instance.updateDefaultPetMeals(withPetId: petId!, withMealName: mealName, andMealData: mealData) {
                DataService.instance.updateDefaultPetMealNotifications(withPetId: petId!, withMealName: mealName, andNotificationData: notificationData) {}
            }
            DataService.instance.updatePetMealNotifications(withPetId: petId!, withMealName: mealName, andNotificationData: notificationData) {
                self.dismiss(animated: true) {
                    self.delegate?.refreshTableView()
                }
            }
        }
    }

    func addGenstures() {
        self.hideKeyboardWhenTappedAround()
        dryButton.setImage(#imageLiteral(resourceName: "DryFoodIcon"), for: .normal)
        dryButton.setImage(#imageLiteral(resourceName: "DryFoodIconSelected"), for: .selected)
        wetButton.setImage(#imageLiteral(resourceName: "WetFoodIcon"), for: .normal)
        wetButton.setImage(#imageLiteral(resourceName: "WetFoodIconSelected"), for: .selected)
        treatButton.setImage(#imageLiteral(resourceName: "TreatFoodIcon"), for: .normal)
        treatButton.setImage(#imageLiteral(resourceName: "TreatFoodIconSelected"), for: .selected)
        dryButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        wetButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        treatButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }

    @objc func foodTypeTapped(_ button: UIButton) {
        switch button {
        case dryButton:
            dryButton.isSelected = true
            wetButton.isSelected = false
            treatButton.isSelected = false
            mealType = "dry"
        case wetButton:
            dryButton.isSelected = false
            wetButton.isSelected = true
            treatButton.isSelected = false
            mealType = "wet"
        case treatButton:
            dryButton.isSelected = false
            wetButton.isSelected = false
            treatButton.isSelected = true
            mealType = "treat"
        default: ()
        }
    }

}

@available(iOS 13.0, *)
extension AddMealVC: AddNotificationDelegate {
    func addNotification(withTime time: String) {
        self.dismiss(animated: true) {
            self.reminderTime = time
            self.addReminderButton.setTitle("Remind me at: " + time, for: .normal)
        }
    }
}
