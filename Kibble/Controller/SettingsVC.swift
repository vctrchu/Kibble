//
//  SettingsViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-02.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var petCodeLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set petcode cell
        petCodeLabel.text = "Pet code: " + LocalStorage.instance.currentUser.currentPet

        // Set notification switch
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            notificationSwitch.isOn = true
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            notificationSwitch.isOn = false
            UIApplication.shared.unregisterForRemoteNotifications()
        }

        notificationSwitch.addTarget(self, action: #selector(switchStateChanged), for: .touchUpInside)
    }

    @objc func switchStateChanged(_ switch: UISwitch) {
        if notificationSwitch.isOn {

        } else {

        }
    }

    @objc func logOutPressed() {

    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!

        if indexPath.row == 0 && indexPath.section == 0 {
            // Pet Code
            let text = LocalStorage.instance.currentUser.currentPet
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(activityViewController, animated: true, completion: nil)
        } else if indexPath.row == 1 && indexPath.section == 0 {
            // Manage members
            DataService.instance.retrieveAllMemberNames(forPetId: LocalStorage.instance.currentUser.currentPet) { (names) in
                let membersVC = self.storyboard?.instantiateViewController(withIdentifier: "MembersVC") as? MembersVC
                membersVC?.setup(names: names)
                self.present(membersVC!, animated: true, completion: nil)
            }
            //performSegue(withIdentifier: "MembersSegue", sender: self)
        } else if indexPath.row == 2 && indexPath.section == 0 {
            // Edit pet info
            performSegue(withIdentifier: "PetInfoSegue", sender: self)
        } else if indexPath.row == 3 && indexPath.section == 0 {
            // Switch pets
            performSegue(withIdentifier: "SwitchPetsSegue", sender: self)
        } else if indexPath.row == 0 && indexPath.section == 2 {
            // Contact us
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["victorchu1996@gmail.com"])
            mail.setSubject("Kibble iOS: Message from User")
            present(mail, animated: true)
        } else if indexPath.row == 1 && indexPath.section == 2 {
            // Rate kibble
            SKStoreReviewController.requestReview()
        }
        cell.isSelected = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


