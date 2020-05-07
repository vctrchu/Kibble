//
//  PetInfoVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-06.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class PetInfoVC: UIViewController {

    // MARK: - Properties

    private var petName: String?
    private var petType: String?
    private var petImage: UIImage?
    private var imagePicker: UIImagePickerController!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var petPhoto: UIImageView!
    @IBOutlet weak var tapToChangeLabel: UILabel!
    @IBOutlet weak var petnameTextField: UITextField! {
        didSet {
            petnameTextField.tintColor = UIColor.gray
            petnameTextField.setIcon(#imageLiteral(resourceName: "PetnameIcon"))
        }
    }
    @IBOutlet weak var typeOfPetTextField: UITextField! {
        didSet {
            typeOfPetTextField.tintColor = UIColor.gray
            typeOfPetTextField.setIcon(#imageLiteral(resourceName: "TypeOfPetIcon"))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func loadView() {
        super.loadView()

        NSLayoutConstraint.activate([
            petnameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            petnameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            petnameTextField.topAnchor.constraint(equalTo: tapToChangeLabel.bottomAnchor, constant: 20.adjusted),
            petnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        petnameTextField.translatesAutoresizingMaskIntoConstraints = false
        petnameTextField.text = petName
        petnameTextField.placeholder = "pet name"
        petnameTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        petnameTextField.layer.cornerRadius = 10
        petnameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        view.addSubview(petnameTextField)

        NSLayoutConstraint.activate([
            typeOfPetTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            typeOfPetTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            typeOfPetTextField.topAnchor.constraint(equalTo: petnameTextField.bottomAnchor, constant: 15.adjusted),
            typeOfPetTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        typeOfPetTextField.translatesAutoresizingMaskIntoConstraints = false
        typeOfPetTextField.text = petType
        typeOfPetTextField.placeholder = "type of pet"
        typeOfPetTextField.font = Device.roundedFont(ofSize: .title1, weight: .medium)
        typeOfPetTextField.layer.cornerRadius = 10
        typeOfPetTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        view.addSubview(typeOfPetTextField)

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petPhoto.layer.cornerRadius = petPhoto.frame.size.width/2
        petPhoto.isUserInteractionEnabled = true
        petPhoto.addGestureRecognizer(tapGestureRecognizer)

        petPhoto.image = petImage

    }

    func setUpProperties(petname: String, petType: String, petImage: UIImage) {
        self.petName = petname
        self.petType = petType
        self.petImage = petImage
    }

    // MARK: - Target Methods

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if petnameTextField.text?.isReallyEmpty ?? true || typeOfPetTextField.text?.isReallyEmpty ?? true {
            saveButton.shake()
        } else {
            DataService.instance.updatePetPhoto(LocalStorage.instance.currentUser.id, petPhoto.image!) { (url) in
                let petData = ["name": self.petnameTextField.text!, "type": self.typeOfPetTextField.text!, "photoUrl": url.absoluteString]
                DataService.instance.updatePetInfo(LocalStorage.instance.currentUser.currentPet, andPetData: petData)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }

}

extension PetInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            petPhoto.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
