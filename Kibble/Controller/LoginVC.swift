//
//  ViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-07.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import FirebaseAuth
import TransitionButton

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func noAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp1", sender: self)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        loginUser()
    }

    func loginUser() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginButton.startAnimation()
            AuthService.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, loginError) in
                if success {
                    self.loginButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
                        mealsVC?.modalPresentationStyle = .fullScreen
                        mealsVC?.modalTransitionStyle = .crossDissolve
                        self.present(mealsVC!, animated: true, completion: nil)
                    })
                } else {
                    print(String(describing: loginError?.localizedDescription))
                    self.loginButton.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 0.75, completion: nil)
                }
            })
        }
    }

}

