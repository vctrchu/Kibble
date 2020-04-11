//
//  TextFieldTapped.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-18.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class Device {
    // Base width in point, use iPhone 6
    static let base: CGFloat = 375

    static var ratio: CGFloat {
        return UIScreen.main.bounds.width / base
    }
}

extension CGFloat {
    var adjusted: CGFloat {
        return self * Device.ratio
    }
}

extension Double {
    var adjusted: CGFloat {
        return CGFloat(self) * Device.ratio
    }
}

extension Int {
    var adjusted: CGFloat {
        return CGFloat(self) * Device.ratio
    }
}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

