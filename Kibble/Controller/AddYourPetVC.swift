//
//  SignUp1.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-01-17.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AddYourPetVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addYourPetTitleImage: UIImageView!
    @IBOutlet weak var petnameTextField: UITextField! {
        didSet {
            petnameTextField.tintColor = UIColor.gray
            petnameTextField.setIcon(#imageLiteral(resourceName: "PetnameIcon"))
        }
    }
    @IBOutlet weak var typeOfPetTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        // viewDidAppear is charge with animations
        petnameTextField.becomeFirstResponder()
    }

    override func loadView() {
        super.loadView()
        addYourPetTitleImage.translatesAutoresizingMaskIntoConstraints = false
        addYourPetTitleImage.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            addYourPetTitleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addYourPetTitleImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.adjusted)
        ])
        self.view.addSubview(addYourPetTitleImage)


        NSLayoutConstraint.activate([
            petnameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            petnameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            petnameTextField.topAnchor.constraint(equalTo: addYourPetTitleImage.bottomAnchor, constant: 15.adjusted),
            petnameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        petnameTextField.translatesAutoresizingMaskIntoConstraints = false
        petnameTextField.layer.backgroundColor = UIColor.white.cgColor
        petnameTextField.placeholder = "pet name"
        petnameTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        petnameTextField.layer.cornerRadius = 10
        petnameTextField.clipsToBounds = true
        petnameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.view.addSubview(petnameTextField)

    }
}
