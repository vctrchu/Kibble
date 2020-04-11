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

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var kibbleMainIcon: UIImageView!
    @IBOutlet weak var signInApple: UIButton!
    @IBOutlet weak var signInGoogle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpAppearance()

    }

    override func loadView() {
        super.loadView()
        setUpAppearance()
    }

    func setUpAppearance() {
        self.view.addSubview(kibbleMainIcon)
        self.view.addSubview(signInApple)
        self.view.addSubview(signInGoogle)

        kibbleMainIcon.translatesAutoresizingMaskIntoConstraints = false
        kibbleMainIcon.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            kibbleMainIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            kibbleMainIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 170.adjusted)
        ])

        signInApple.translatesAutoresizingMaskIntoConstraints = false
        signInApple.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            signInApple.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInApple.bottomAnchor.constraint(equalTo: signInGoogle.topAnchor, constant: -25.adjusted)
        ])

        signInGoogle.translatesAutoresizingMaskIntoConstraints = false
        signInGoogle.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            signInGoogle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInGoogle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.adjusted)
        ])

    }
    
    @IBAction func noAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp1", sender: self)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        loginUser()
    }

    // UITextFieldDelegate method to change textfields when pressing 'return'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginUser()
        }
        return true
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

