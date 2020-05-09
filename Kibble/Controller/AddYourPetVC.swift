//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import SimpleAnimation
import Pastel

@available(iOS 13.0, *)
class AddYourPetVC: UIViewController {

    // MARK: - Properties

    @IBOutlet var pastelView: PastelView!
    @IBOutlet weak var addYourPetTitleImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var petnameTextField: UITextField! {
        didSet {
            petnameTextField.tintColor = UIColor.gray
            petnameTextField.setIcon(#imageLiteral(resourceName: "PetnameIcon"))
        }
    }
    @IBOutlet weak var typeOfPetTextField: UITextField! {
        didSet {
            typeOfPetTextField.tintColor = UIColor.gray
            typeOfPetTextField.setIcon(#imageLiteral(resourceName: "TypeOfPetIcon"))
        }
    }

    var lastPastelView: PastelView?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        petnameTextField.delegate = self
        typeOfPetTextField.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        // viewDidAppear is in charge with animations of the vc before we create it
        petnameTextField.becomeFirstResponder()
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3
        pastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1),#colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.9019607843, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1)])
        pastelView.startAnimation()
        addYourPetTitleImage.fadeIn(duration: 1, delay: 0) { (Bool) in
            self.petnameTextField.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                self.typeOfPetTextField.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                    self.nextButton.fadeIn(duration: 0.5, delay: 0) { (Bool) in
                    }
                }
            }
        }
    }

    // MARK: - Auto Constraints

    override func loadView() {
        super.loadView()
        addYourPetTitleImage.translatesAutoresizingMaskIntoConstraints = false
        addYourPetTitleImage.contentMode = UIView.ContentMode.scaleAspectFit
        addYourPetTitleImage.alpha = 0
        NSLayoutConstraint.activate([
            addYourPetTitleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addYourPetTitleImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110.adjusted)
        ])
        self.view.addSubview(addYourPetTitleImage)

        NSLayoutConstraint.activate([
            petnameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            petnameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            petnameTextField.topAnchor.constraint(equalTo: addYourPetTitleImage.bottomAnchor, constant: 20.adjusted),
            petnameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        petnameTextField.alpha = 0
        petnameTextField.translatesAutoresizingMaskIntoConstraints = false
        petnameTextField.layer.backgroundColor = UIColor.white.cgColor
        petnameTextField.placeholder = "pet name"
        petnameTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        petnameTextField.layer.cornerRadius = 10
        petnameTextField.clipsToBounds = true
        petnameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.view.addSubview(petnameTextField)

        NSLayoutConstraint.activate([
            typeOfPetTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            typeOfPetTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            typeOfPetTextField.topAnchor.constraint(equalTo: petnameTextField.bottomAnchor, constant: 15.adjusted),
            typeOfPetTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        typeOfPetTextField.alpha = 0
        typeOfPetTextField.translatesAutoresizingMaskIntoConstraints = false
        typeOfPetTextField.layer.backgroundColor = UIColor.white.cgColor
        typeOfPetTextField.placeholder = "type of pet"
        typeOfPetTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        typeOfPetTextField.layer.cornerRadius = 10
        typeOfPetTextField.clipsToBounds = true
        typeOfPetTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.view.addSubview(typeOfPetTextField)

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: typeOfPetTextField.bottomAnchor, constant: 30.adjusted),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        nextButton.alpha = 0
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.contentMode = UIView.ContentMode.scaleAspectFit
        self.view.addSubview(nextButton)

    }

    // MARK: - Add Target Methods

    @objc func nextButtonPressed() {
        if petnameTextField.text?.isReallyEmpty ?? true || typeOfPetTextField.text?.isReallyEmpty ?? true {
            nextButton.shake()
        } else {
            let petID = Device.randomString()
            let petname = petnameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let typeOfPet = typeOfPetTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let petData: Dictionary<String, Any> = ["name": petname,
                                                    "type": typeOfPet]

            let addFirstMealVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourFirstMealVC") as? AddYourFirstMealVC
            addFirstMealVC?.modalPresentationStyle = .fullScreen
            addFirstMealVC?.isMotionEnabled = true
            addFirstMealVC?.motionTransitionType = .fade
            addFirstMealVC?.setupVariables(petId: petID, petData: petData)
            self.present(addFirstMealVC!, animated: true, completion: nil)
        }
    }
}

// Keyboard return key moves to next text field
@available(iOS 13.0, *)
extension AddYourPetVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == petnameTextField {
            textField.resignFirstResponder()
            typeOfPetTextField.becomeFirstResponder()
        } else if textField == typeOfPetTextField {
            textField.resignFirstResponder()
            nextButtonPressed()
        }
        return true
    }
}
