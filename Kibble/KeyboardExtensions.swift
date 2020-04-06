//
//  TextFieldTapped.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-18.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

//    @objc func keyboardWillChange(notification: Notification) {
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            view.frame.origin.y -= 60
//        } else {
//            view.frame.origin.y = 0
//        }
//    }

    func setUpAnimation() {
        hideKeyboardWhenTappedAround()
        isMotionEnabled = true
        motionTransitionType = .slide(direction: .left)
    }

//    func setUpNotifications() {
//        // Listen for keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
    
}
