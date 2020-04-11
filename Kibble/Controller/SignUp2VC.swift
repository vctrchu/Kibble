//
//  SignUp2VC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-28.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton

class SignUp2VC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var completeButton: TransitionButton!
    var fullNameText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUpAnimation()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //self.setUpNotifications()
    }

    //    deinit {
    //        // Stop listening for keyboard hide/show events
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    //    }


    func registerUser() {
        if  let email = emailTextField.text, let password = passwordTextField.text {
            //            if email.isEmpty || password.isEmpty {
            //                completeButton.shake()
            //            } else {
            //            }
            completeButton.startAnimation()
            AuthService.instance.registerUser(fullName: fullNameText, withEmail: email, andPassword: password, userCreationComplete: { (success, signupError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, loginComplete: { (success, nil) in
                        self.completeButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                            let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
                            mealsVC?.modalPresentationStyle = .fullScreen
                            mealsVC?.modalTransitionStyle = .crossDissolve
                            self.present(mealsVC!, animated: true, completion: nil)
                        })
                    })
                } else {
                    print(String(describing: signupError?.localizedDescription))
                    self.completeButton.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 1, completion: nil)
                }
            })
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        motionTransitionType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func completeButtonPressed(_ sender: Any) {
        registerUser()
    }

    // TextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            registerUser()
        }
        return true
    }

}
