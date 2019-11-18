//
//  AddMealVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-18.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class AddMealVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
