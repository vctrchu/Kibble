//
//  TextFieldTapped.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-18.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class Device {

    static func randomString() -> String {
        let length = 6;
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    // Base width in point, use iPhone 6
    static let base: CGFloat = 375

    static var ratio: CGFloat {
        return UIScreen.main.bounds.width / base
    }

    @available(iOS 13.0, *)
    static func roundedFont(ofSize style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
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

extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
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

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 20, y: 5, width: 20, height: 20))
        iconView.image = image
        iconView.alpha = 0.2
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 50, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
