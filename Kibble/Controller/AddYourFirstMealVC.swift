//
//  AddYourFirstMealVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-14.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Motion
import SimpleAnimation

@available(iOS 13.0, *)
class AddYourFirstMealVC: UIViewController {

    @IBOutlet weak var almostThereTitle: UIImageView!
    @IBOutlet weak var mealNameTextField: UITextField! {
        didSet {
            mealNameTextField.tintColor = UIColor.gray
            mealNameTextField.setIcon(#imageLiteral(resourceName: "MealNameIcon"))
        }
    }
    @IBOutlet weak var foodButtonsStackView: UIStackView!
    @IBOutlet weak var dryFoodButton: UIButton!
    @IBOutlet weak var wetFoodButton: UIButton!
    @IBOutlet weak var treatFoodButton: UIButton!
    @IBOutlet weak var saveMealButton: UIButton!
    @IBOutlet weak var selectTypeOfFoodTitle: UIImageView!
    @IBOutlet weak var orTitle: UIImageView!
    @IBOutlet weak var joinExistingScheduleButton: UIButton!

    var petId = ""
    var petData = Dictionary<String, Any>()
    var mealType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        addGenstures()
    }

    override func loadView() {
        super.loadView()

        almostThereTitle.translatesAutoresizingMaskIntoConstraints = false
        almostThereTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            almostThereTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110.adjusted),
            almostThereTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(almostThereTitle)

        mealNameTextField.translatesAutoresizingMaskIntoConstraints = false
        mealNameTextField.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            mealNameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            mealNameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            mealNameTextField.topAnchor.constraint(equalTo: almostThereTitle.bottomAnchor, constant: 20.adjusted),
            mealNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        mealNameTextField.layer.backgroundColor = UIColor.white.cgColor
        mealNameTextField.placeholder = "meal name"
        mealNameTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        mealNameTextField.layer.cornerRadius = 10
        mealNameTextField.clipsToBounds = true
        mealNameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.view.addSubview(mealNameTextField)

        selectTypeOfFoodTitle.translatesAutoresizingMaskIntoConstraints = false
        selectTypeOfFoodTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            selectTypeOfFoodTitle.topAnchor.constraint(equalTo: mealNameTextField.bottomAnchor, constant: 20.adjusted),
            selectTypeOfFoodTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(selectTypeOfFoodTitle)

        foodButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        foodButtonsStackView.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            foodButtonsStackView.topAnchor.constraint(equalTo: selectTypeOfFoodTitle.bottomAnchor, constant: 15.adjusted),
            foodButtonsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(foodButtonsStackView)

        saveMealButton.translatesAutoresizingMaskIntoConstraints = false
        saveMealButton.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            saveMealButton.topAnchor.constraint(equalTo: foodButtonsStackView.bottomAnchor, constant: 15.adjusted),
            saveMealButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(saveMealButton)

        orTitle.translatesAutoresizingMaskIntoConstraints = false
        orTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            orTitle.topAnchor.constraint(equalTo: saveMealButton.bottomAnchor, constant: -20.adjusted),
            orTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(orTitle)

        joinExistingScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        joinExistingScheduleButton.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            joinExistingScheduleButton.topAnchor.constraint(equalTo: orTitle.bottomAnchor, constant: 20.adjusted),
            joinExistingScheduleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(joinExistingScheduleButton)
    }

    func addGenstures() {
        self.hideKeyboardWhenTappedAround()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        dryFoodButton.setImage(#imageLiteral(resourceName: "DryFoodIcon"), for: .normal)
        dryFoodButton.setImage(#imageLiteral(resourceName: "DryFoodIconSelected"), for: .selected)
        wetFoodButton.setImage(#imageLiteral(resourceName: "WetFoodIcon"), for: .normal)
        wetFoodButton.setImage(#imageLiteral(resourceName: "WetFoodIconSelected"), for: .selected)
        treatFoodButton.setImage(#imageLiteral(resourceName: "TreatFoodIcon"), for: .normal)
        treatFoodButton.setImage(#imageLiteral(resourceName: "TreatFoodIconSelected"), for: .selected)
        dryFoodButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        wetFoodButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        treatFoodButton.addTarget(self, action: #selector(foodTypeTapped), for: .touchUpInside)
        saveMealButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }

    @objc func foodTypeTapped(_ button: UIButton) {
        switch button {
        case dryFoodButton:
            dryFoodButton.isSelected = true
            wetFoodButton.isSelected = false
            treatFoodButton.isSelected = false
            mealType = "dry"
        case wetFoodButton:
            dryFoodButton.isSelected = false
            wetFoodButton.isSelected = true
            treatFoodButton.isSelected = false
            mealType = "wet"
        case treatFoodButton:
            dryFoodButton.isSelected = false
            wetFoodButton.isSelected = false
            treatFoodButton.isSelected = true
            mealType = "treat"
        default: ()
        }
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            motionTransitionType = .slide(direction: .right)
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func saveButtonPressed() {
        if mealNameTextField.text?.isReallyEmpty ?? true ||
            !(dryFoodButton.isSelected || wetFoodButton.isSelected || treatFoodButton.isSelected){
            saveMealButton.shake()
        } else {
            let mealName = mealNameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

            let allowNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "AllowNotificationsVC") as? AllowNotificationsVC
            allowNotificationsVC?.modalPresentationStyle = .fullScreen
            allowNotificationsVC?.isMotionEnabled = true
            allowNotificationsVC?.motionTransitionType = .slide(direction: .left)
            allowNotificationsVC?.petId = petId
            allowNotificationsVC?.petData = petData
            allowNotificationsVC?.mealName = mealName
            allowNotificationsVC?.mealType = mealType
            self.present(allowNotificationsVC!, animated: true, completion: nil)
        }
    }
}
