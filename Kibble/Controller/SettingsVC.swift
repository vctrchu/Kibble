//
//  SettingsViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-02.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import StoreKit

//protocol SettingsDelegate {
//    func refreshTableView()
//}

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var petCodeLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    private var petCodeTextField: UITextField?
    //var delegate: SettingsDelegate?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set petcode cell
        DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
            self.petCodeLabel.text = "Pet code: " + petId
        }
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
    }

    @objc func logOutPressed(){
        let alert = UIAlertController(title: "Are you sure you want to log out of Kibble?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let logoutFailure = UIAlertController(title: "Logout failed. Please try again or check your connection", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                if let providerId = Auth.auth().currentUser?.providerData.first?.providerID, providerId == "apple.com" {
                    // Clear saved user ID
                    UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
                }
                try Auth.auth().signOut()
                let signInVC = self.storyboard?.instantiateViewController(identifier: "SignInVC") as! SignInVC
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: true, completion: nil)
            } catch {
                print(error)
                self.present(logoutFailure, animated: true, completion: nil)
            }
        }))

        logoutFailure.addAction(UIAlertAction(title: "Dimiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!

        // Pet Code
        if indexPath.row == 0 && indexPath.section == 0 {
            DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
                let textToShare = [ petId ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                self.present(activityViewController, animated: true, completion: nil)
            }
        }

        // Manage members
        else if indexPath.row == 1 && indexPath.section == 0 {
            DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
                DataService.instance.retrieveAllMemberNames(forPetId: petId) { (names) in
                    let membersVC = self.storyboard?.instantiateViewController(withIdentifier: "MembersVC") as? MembersVC
                    membersVC?.setup(names: names)
                    self.present(membersVC!, animated: true, completion: nil)
                }
            }
        }

        // Edit pet info
        else if indexPath.row == 2 && indexPath.section == 0 {
            let petInfoVC = self.storyboard?.instantiateViewController(identifier: "PetInfoVC") as! PetInfoVC
            self.present(petInfoVC, animated: true, completion: nil)
        }

        // Switch pets
        else if indexPath.row == 3 && indexPath.section == 0 {
            let switchPetsVC = self.storyboard?.instantiateViewController(withIdentifier: "SwitchPetsVC") as? SwitchPetsVC
            self.present(switchPetsVC!, animated: true, completion: nil)
        }

        // Show uialert() to join with textfield to enter a join code
        else if indexPath.row == 4 && indexPath.section == 0 {
            let alertController = UIAlertController(title: "Enter pet code", message: nil, preferredStyle: .alert)

            let joinAction = UIAlertAction(title: "Join", style: .default) { (joinHandler) in
                //var success = false
                // start a loading indicator here

                // 1. Retreive petID, else alert user the id is wrong
                if let enteredPetId = self.petCodeTextField?.text {
                    DataService.instance.retrievePet(enteredPetId) { (returnedPet) in
                        if let pet = returnedPet {
                            // 2. Update userID current petId to the entered petID
                            let uid = Auth.auth().currentUser!.uid
                            DataService.instance.updateUser(withUid: uid, withUserData: ["currentPet": pet.id])
                            DataService.instance.addPetToUser(forUid: uid, withPetId: pet.id)
                            DataService.instance.updatePetMembers(withPetId: pet.id, andMemberData: [uid: Auth.auth().currentUser!.displayName])
                            self.tableView.reloadData()
                        } else {
                            let errorAlertController = UIAlertController(title: "Invalid pet code", message: "Please try again", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            errorAlertController.addAction(okAction)
                            self.present(errorAlertController, animated: true, completion: nil)                        }
                    }
                }
            }
            joinAction.isEnabled = false

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alertController.addTextField { (textField) in
                self.petCodeTextField = textField
                self.petCodeTextField?.placeholder = "ABC123"

                // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        var enableTextField = true
                        if textField.text?.isReallyEmpty ?? true {
                            enableTextField = false
                        }
                        joinAction.isEnabled = enableTextField
                })
            }

            alertController.addAction(joinAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }

        // Create new pet
        else if indexPath.row == 5 && indexPath.section == 0 {
            let addPetVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourPetVC") as! AddYourPetVC
            addPetVC.modalPresentationStyle = .fullScreen
            self.present(addPetVC, animated: true, completion: nil)
        }

        // Contact us
        else if indexPath.row == 0 && indexPath.section == 1 {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["victorchu1996@gmail.com"])
            mail.setSubject("Kibble iOS: Message from User")
            present(mail, animated: true)
        }

        // Rate kibble
        else if indexPath.row == 1 && indexPath.section == 1 {
            SKStoreReviewController.requestReview()
        }
        cell.isSelected = false
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


