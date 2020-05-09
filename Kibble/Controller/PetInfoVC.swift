//
//  PetInfoVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-06.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

class PetInfoVC: UIViewController {

    // MARK: - Properties
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

    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
            DataService.instance.retrievePet(petId) { (returnedPet) in
                var petImage = UIImage()
                if let pet = returnedPet {
                    if let imageUrlString = pet.photoUrl {
                        let imageUrl = URL(string: imageUrlString)!
                        let imageData = try! Data(contentsOf: imageUrl)
                        let image = UIImage(data: imageData)
                        petImage = image!
                    } else {
                        petImage = #imageLiteral(resourceName: "dog")
                    }
                    self.petnameTextField.text = pet.name
                    self.typeOfPetTextField.text = pet.type
                }
                self.petPhoto.image = petImage
                self.petPhoto.fadeIn(duration: 0.25, delay: 0, completion: nil)
                self.petnameTextField.fadeIn(duration: 0.25, delay: 0, completion: nil)
                self.typeOfPetTextField.fadeIn(duration: 0.25, delay: 0, completion: nil)
            }
        }
    }

    override func loadView() {
        super.loadView()
        NSLayoutConstraint.activate([
            petnameTextField.heightAnchor.constraint(equalToConstant: 60.adjusted),
            petnameTextField.widthAnchor.constraint(equalToConstant: 301.adjusted),
            petnameTextField.topAnchor.constraint(equalTo: tapToChangeLabel.bottomAnchor, constant: 20.adjusted),
            petnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        petnameTextField.alpha = 0
        petnameTextField.translatesAutoresizingMaskIntoConstraints = false
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
        typeOfPetTextField.alpha = 0
        typeOfPetTextField.translatesAutoresizingMaskIntoConstraints = false
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
        petPhoto.alpha = 0
    }

    // MARK: - Target Methods

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if petnameTextField.text?.isReallyEmpty ?? true || typeOfPetTextField.text?.isReallyEmpty ?? true {
            saveButton.shake()
        } else {
            DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
                DataService.instance.updatePetPhoto(petId, self.petPhoto.image!) { (url) in
                    let petData = ["name": self.petnameTextField.text!, "type": self.typeOfPetTextField.text!, "photoUrl": url.absoluteString]
                    DataService.instance.updatePetInfo(petId, andPetData: petData)
                    self.dismiss(animated: true, completion: nil)
                }
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
