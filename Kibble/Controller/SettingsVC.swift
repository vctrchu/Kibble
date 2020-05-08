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

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var petCodeLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set petcode cell
        petCodeLabel.text = "Pet code: " + LocalStorage.instance.currentUser.currentPet
        //logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
    }

    @objc func logOutPressed(){
           let alert = UIAlertController(title: "Are you sure you want to log out of Kibble?", message: nil, preferredStyle: UIAlertController.Style.alert)
           let logoutFailure = UIAlertController(title: "Logout failed. Please try again or check your connection", message: nil, preferredStyle: .alert)

           alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
               alert.dismiss(animated: true, completion: nil)
           }))

           alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (action) in
               do {
                   try Auth.auth().signOut()
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
            let text = LocalStorage.instance.currentUser.currentPet
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(activityViewController, animated: true, completion: nil)
        }

        // Manage members
        else if indexPath.row == 1 && indexPath.section == 0 {
            DataService.instance.retrieveAllMemberNames(forPetId: LocalStorage.instance.currentUser.currentPet) { (names) in
                let membersVC = self.storyboard?.instantiateViewController(withIdentifier: "MembersVC") as? MembersVC
                membersVC?.setup(names: names)
                self.present(membersVC!, animated: true, completion: nil)
            }
        }

        // Edit pet info
        else if indexPath.row == 2 && indexPath.section == 0 {
            let petInfoVC = self.storyboard?.instantiateViewController(identifier: "PetInfoVC") as! PetInfoVC
            self.present(petInfoVC, animated: true, completion: nil)
        }

        // Switch pets
        else if indexPath.row == 3 && indexPath.section == 0 {
            performSegue(withIdentifier: "SwitchPetsSegue", sender: self)
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


