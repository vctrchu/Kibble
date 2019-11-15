//
//  LaunchScreenVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-10.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Motion

// This is a custom class which delays the presentation of the next viewcontroller.
class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            if AccessToken.current != nil {
                self.presentMealsVC()
            }
            else {
                self.presentLoginVC()
            }
            
        }
    }
    
    private func presentMealsVC() {
        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC")
        mealsVC?.modalPresentationStyle = .fullScreen
        mealsVC?.modalTransitionStyle = .crossDissolve
        self.present(mealsVC!, animated: true, completion: nil)
    }
    
    private func presentLoginVC() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        loginVC?.modalPresentationStyle = .fullScreen
        loginVC?.modalTransitionStyle = .crossDissolve
        self.present(loginVC!, animated: true, completion: nil)
    }

}
