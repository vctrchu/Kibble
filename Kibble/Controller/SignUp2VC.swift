//
//  SignUp2VC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-28.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class SignUp2VC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    weak var delegate: SignUp2VC?
    var fullNameText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
