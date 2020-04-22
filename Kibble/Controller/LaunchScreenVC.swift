//
//  LaunchScreenVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-10.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import Motion

// This is a custom class which delays the presentation of the next viewcontroller.
class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Auth.auth().currentUser == nil ? self.presentSignInVC() : self.presentTestVC()

            //self.presentSignInVC()
        }
    }

    private func presentTestVC() {
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourPetVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.isMotionEnabled = true
        mealsVC?.motionTransitionType = .fade
        self.present(mealsVC!, animated: true, completion: nil)
    }
    
    private func presentMealsVC() {
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.isMotionEnabled = true
        mealsVC?.motionTransitionType = .fade
        self.present(mealsVC!, animated: true, completion: nil)
    }
    
    private func presentSignInVC() {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")
        signinVC?.modalPresentationStyle = .fullScreen
        self.present(signinVC!, animated: true, completion: nil)
    }

}
