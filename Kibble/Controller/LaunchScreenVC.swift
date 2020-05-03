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
import Pastel

// This is a custom class which delays the presentation of the next viewcontroller.
class LaunchScreenVC: UIViewController {
    
    @IBOutlet var pastelView: PastelView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Auth.auth().currentUser == nil ? self.presentSignInVC() : self.presentMealsVC()
            //self.presentSignInVC()
            //self.presentTestVC()
            DataService.instance.setup()
        }
    }

    override func loadView() {
        super.loadView()
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3
        pastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)])
        pastelView.startAnimation()
    }

    private func presentTestVC() {
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotifictionsVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.isMotionEnabled = true
        mealsVC?.motionTransitionType = .fade
        self.present(mealsVC!, animated: true, completion: nil)
    }
    
    private func presentMealsVC() {
        let uid = Auth.auth().currentUser!.uid
        DataService.instance.retrieveAllPetsForUser(withUid: uid)
        DataService.instance.downloadPetIds()
        DataService.instance.retrieveAllUserInfo(withUid: uid) {
            let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC") as! MealsVC
            mealsVC.modalPresentationStyle = .fullScreen
            mealsVC.isMotionEnabled = true
            mealsVC.motionTransitionType = .fade
            self.present(mealsVC, animated: true, completion: nil)
        }
    }
    
    private func presentSignInVC() {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")
        signinVC?.modalPresentationStyle = .fullScreen
        self.present(signinVC!, animated: true, completion: nil)
    }

}
