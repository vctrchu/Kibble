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

    @IBOutlet weak var kibbleMainIcon: UIImageView!
    @IBOutlet weak var signInApple: UIButton!
    @IBOutlet weak var signInGoogle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpAppearance()

    }

    override func loadView() {
        super.loadView()
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



}

