//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton
import IHKeyboardAvoiding

class SignUp1VC: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nextButton: TransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimations()

    }

    func setUpAnimations() {
        KeyboardAvoiding.avoidingView = nextButton
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp2" {
            if let signupVC2 = segue.destination as? SignUp2VC {
                let fullName = firstNameTextField.text!.capitalized + " " + lastNameTextField.text!.capitalized
                signupVC2.fullNameText = fullName
            }
        }
    }
}
