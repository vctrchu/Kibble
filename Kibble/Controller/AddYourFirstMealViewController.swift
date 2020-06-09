//
//  AddYourFirstMealVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-14.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import Motion
import SimpleAnimation
import Pastel

@available(iOS 13.0, *)
class AddYourFirstMealViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var pastelView: PastelView!
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

    private var petCodeTextField: UITextField?
    private var petId = ""
    private var mealType = ""
    private var petData = Dictionary<String, Any>()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }

    override func viewDidAppear(_ animated: Bool) {
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3
        pastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1),#colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.9019607843, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1)])
        pastelView.startAnimation()
        almostThereTitle.fadeIn(duration: 1, delay: 0) { (Bool) in
            self.mealNameTextField.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                self.selectTypeOfFoodTitle.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                    self.foodButtonsStackView.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                        self.saveMealButton.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                            self.orTitle.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                                self.joinExistingScheduleButton.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func setupVariables(petId: String, petData: [String:Any]) {
        self.petId = petId
        self.petData = petData
    }

    // MARK: - Auto Constraints

    override func loadView() {
        super.loadView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)]
        gradientLayer.frame = view.bounds
        pastelView.layer.insertSublayer(gradientLayer, at: 0)
        
        almostThereTitle.translatesAutoresizingMaskIntoConstraints = false
        almostThereTitle.contentMode = UIView.ContentMode.scaleAspectFit
        almostThereTitle.alpha = 0
        NSLayoutConstraint.activate([
            almostThereTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110.adjusted),
            almostThereTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(almostThereTitle)

        mealNameTextField.translatesAutoresizingMaskIntoConstraints = false
        mealNameTextField.contentMode = UIView.ContentMode.scaleAspectFit
        mealNameTextField.alpha = 0
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
        selectTypeOfFoodTitle.alpha = 0
        NSLayoutConstraint.activate([
            selectTypeOfFoodTitle.topAnchor.constraint(equalTo: mealNameTextField.bottomAnchor, constant: 20.adjusted),
            selectTypeOfFoodTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(selectTypeOfFoodTitle)

        foodButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        foodButtonsStackView.contentMode = UIView.ContentMode.scaleAspectFit
        foodButtonsStackView.alpha = 0
        NSLayoutConstraint.activate([
            foodButtonsStackView.topAnchor.constraint(equalTo: selectTypeOfFoodTitle.bottomAnchor, constant: 15.adjusted),
            foodButtonsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(foodButtonsStackView)

        saveMealButton.translatesAutoresizingMaskIntoConstraints = false
        saveMealButton.contentMode = UIView.ContentMode.scaleAspectFit
        saveMealButton.alpha = 0
        NSLayoutConstraint.activate([
            saveMealButton.topAnchor.constraint(equalTo: foodButtonsStackView.bottomAnchor, constant: 15.adjusted),
            saveMealButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(saveMealButton)

        orTitle.translatesAutoresizingMaskIntoConstraints = false
        orTitle.contentMode = UIView.ContentMode.scaleAspectFit
        orTitle.alpha = 0
        NSLayoutConstraint.activate([
            orTitle.topAnchor.constraint(equalTo: saveMealButton.bottomAnchor, constant: -20.adjusted),
            orTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(orTitle)

        joinExistingScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        joinExistingScheduleButton.contentMode = UIView.ContentMode.scaleAspectFit
        joinExistingScheduleButton.addTarget(self, action: #selector(joinExistingSchedulePressed), for: .touchUpInside)
        joinExistingScheduleButton.alpha = 0
        NSLayoutConstraint.activate([
            joinExistingScheduleButton.topAnchor.constraint(equalTo: orTitle.bottomAnchor, constant: 20.adjusted),
            joinExistingScheduleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.view.addSubview(joinExistingScheduleButton)
    }

    // MARK: - Gesutures

    func addGestures() {
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

    // MARK: - Add Target Methods

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

            let allowNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "AllowNotificationsVC") as! AllowNotificationsViewController
            allowNotificationsVC.modalPresentationStyle = .fullScreen
            allowNotificationsVC.isMotionEnabled = true
            allowNotificationsVC.motionTransitionType = .fade
            allowNotificationsVC.setupVariables(petId: petId, petData: petData, mealName: mealName, mealType: mealType)
            self.present(allowNotificationsVC, animated: true, completion: nil)
        }
    }

    @objc func joinExistingSchedulePressed() {
        let alertController = UIAlertController(title: "Enter pet code", message: nil, preferredStyle: .alert)

        let joinAction = UIAlertAction(title: "Join", style: .default) { (joinHandler) in
            // 1. Retreive petID, else alert user the id is wrong
            if let enteredPetId = self.petCodeTextField?.text {
                DataService.instance.retrievePet(enteredPetId) { (returnedPet) in
                    if let pet = returnedPet {
                        // 2. Update userID current petId to the entered petID
                        let uid = Auth.auth().currentUser!.uid
                        DataService.instance.addPetToUser(forUid: uid, withPetId: pet.id)
                        DataService.instance.updatePetMembers(withPetId: pet.id, andMemberData: [uid: Auth.auth().currentUser!.displayName])
                        DataService.instance.updateUserCompletion(uid, ["currentPet": pet.id]) {
                            // present mealsVC once database is updated....
                            let mealsVC = self.storyboard?.instantiateViewController(identifier: "MealsVC") as! MealsViewController
                            mealsVC.modalPresentationStyle = .fullScreen
                            mealsVC.motionTransitionType = .fade
                            self.present(mealsVC, animated: true, completion: nil)
                        }

                    } else {
                        let errorAlertController = UIAlertController(title: "Invalid pet code", message: "Please try again", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        errorAlertController.addAction(okAction)
                        self.present(errorAlertController, animated: true, completion: nil)
                    }
                }
            }
        }

        joinAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addTextField { (textField) in
              self.petCodeTextField = textField
              self.petCodeTextField?.placeholder = "ABC123"

              // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
              NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                  {_ in
                      var enableTextField = true
                      if textField.text?.isReallyEmpty ?? true {
                          enableTextField = false
                      }
                      joinAction.isEnabled = enableTextField
              })
          }
        alertController.addAction(joinAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
