//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton
import SimpleAnimation
import IHKeyboardAvoiding

class SignUp1VC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nextButton: TransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAnimation()
        //self.setUpNotifications()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }

//    deinit {
//        // Stop listening for keyboard hide/show events
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }


    @IBAction func backButtonPressed(_ sender: Any) {
        motionTransitionType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! {
            nextButton.shake()
        } else {
            performSegue(withIdentifier: "toSignUp2", sender: self)
        }
    }

    // TextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            nextButtonPressed(self)
        }
        return true
    }

    // Prepare data to be passed to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp2" {
            if let signupVC2 = segue.destination as? SignUp2VC {
                let fullName = firstNameTextField.text!.capitalized + " " + lastNameTextField.text!.capitalized
                signupVC2.fullNameText = fullName
            }
        }
    }
}
