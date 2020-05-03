//
//  SettingsViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-02.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}


