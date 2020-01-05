//
//  AddMealVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-18.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class AddMealVC: UIViewController {
    
    @IBOutlet weak var mealLabelTextField: UITextField!
    @IBOutlet weak var extraInfoTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
