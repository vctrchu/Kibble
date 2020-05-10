//
//  AddReminderVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-26.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddNotificationDelegate {
    func addNotification(withTime time: String)
}

class AddReminderVC: UIViewController {

    //MARK: - Properties

    @IBOutlet weak var addReminderTitle: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var delegate: AddNotificationDelegate?
    var time: String?

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Auto Constraints

    override func loadView() {
        super.loadView()
        self.view.addSubview(addReminderTitle)
        self.view.addSubview(datePicker)
        self.view.addSubview(addButton)

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        addReminderTitle.translatesAutoresizingMaskIntoConstraints = false
        addReminderTitle.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            addReminderTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.adjusted),
            addReminderTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        if let time = time {
            let date = dateFormatter.date(from: time)
            datePicker.date = date!
        }

        datePicker.datePickerMode = .time
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: self.addReminderTitle.bottomAnchor, constant: 20.adjusted)
        ])

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40.adjusted),
            addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

    }

    //MARK: - Add Target Methods

    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func addButtonPressed() {
        print("\(getTimePickerValue())")
        delegate?.addNotification(withTime: getTimePickerValue())
    }


    func getTimePickerValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: datePicker.date)
    }

}
