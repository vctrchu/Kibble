//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import SimpleAnimation

@available(iOS 13.0, *)
class AddYourPetVC: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        petnameTextField.delegate = self
        typeOfPetTextField.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        // viewDidAppear is in charge with animations of the vc before we create it
        petnameTextField.becomeFirstResponder()
    }

    override func loadView() {
        super.loadView()
        addYourPetTitleImage.translatesAutoresizingMaskIntoConstraints = false
        addYourPetTitleImage.contentMode = UIView.ContentMode.scaleAspectFit
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
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.contentMode = UIView.ContentMode.scaleAspectFit
        self.view.addSubview(nextButton)

    }

    @objc func nextButtonPressed() {
        if petnameTextField.text?.isReallyEmpty ?? true || typeOfPetTextField.text?.isReallyEmpty ?? true {
            nextButton.shake()
        } else {

            let petame = petnameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let typeOfPet = typeOfPetTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

            let addFirstMealVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourFirstMealVC")
            addFirstMealVC?.modalPresentationStyle = .fullScreen
            addFirstMealVC?.isMotionEnabled = true
            addFirstMealVC?.motionTransitionType = .slide(direction: .left)
            self.present(addFirstMealVC!, animated: true, completion: nil)
        }
    }

}

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
