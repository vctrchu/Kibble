//
//  AddMealVCViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-24.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

protocol AddMealDelegate {
    func refreshTableView()
}

@available(iOS 13.0, *)
class AddMealVC: UIViewController {

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

    var mealType: String?
    var reminderTime: String?
    var delegate: AddMealDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGenstures()
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(cancelButton)
        self.view.addSubview(addMealTitle)
        self.view.addSubview(mealNameTextField)
        self.view.addSubview(typeFoodStackView)
        self.view.addSubview(typeOfFoodTitle)
        self.view.addSubview(addReminderButton)
        self.view.addSubview(saveButton)

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        addMealTitle.translatesAutoresizingMaskIntoConstraints = false
        addMealTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            addMealTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50.adjusted),
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
            mealNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mealNameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            mealNameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted)
        ])

        typeOfFoodTitle.translatesAutoresizingMaskIntoConstraints = false
        typeOfFoodTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeOfFoodTitle.topAnchor.constraint(equalTo: mealNameTextField.bottomAnchor, constant: 20.adjusted),
            typeOfFoodTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        typeFoodStackView.translatesAutoresizingMaskIntoConstraints = false
        typeFoodStackView.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeFoodStackView.topAnchor.constraint(equalTo: typeOfFoodTitle.bottomAnchor, constant: 20.adjusted),
            typeFoodStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        addReminderButton.translatesAutoresizingMaskIntoConstraints = false
        addReminderButton.contentMode = UIView.ContentMode.scaleAspectFit
        addReminderButton.setTitle("Add Reminder", for: .normal)
        addReminderButton.setTitleColor(UIColor.white, for: .normal)
        addReminderButton.addTarget(self, action: #selector(addReminderPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addReminderButton.topAnchor.constraint(equalTo: typeFoodStackView.bottomAnchor, constant: 20.adjusted),
            addReminderButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: 20.adjusted),
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }

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

    func dismissVC() {
        let mealName = mealNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
         let petId = LocalStorage.instance.currentUser.currentPet
         let mealData = ["isFed": "false", "type": mealType]
         DataService.instance.updatePetMeals(withPetId: petId , withMealName: mealName, andMealData: mealData)
         let notificationData: Dictionary<String, Any> = ["notification" : reminderTime]
         DataService.instance.updatePetMealNotifications(withPetId: petId, withMealName: mealName, andNotificationData: notificationData) {
             self.dismiss(animated: true) {
                 self.delegate?.refreshTableView()
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
