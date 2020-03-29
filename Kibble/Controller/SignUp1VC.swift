//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton

class SignUp1VC: UIViewController {

    @IBOutlet weak var nextButton: TransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp2", sender: self)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
