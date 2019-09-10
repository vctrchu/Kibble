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
                self.presentJoinVC()
            }
            else {
                self.presentLoginVC()
            }
            
        }
    }
    
    private func presentJoinVC() {
        let joinVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinVC")
        joinVC?.modalTransitionStyle = .crossDissolve
        self.present(joinVC!, animated: true, completion: nil)
    }
    
    private func presentLoginVC() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        loginVC?.modalTransitionStyle = .crossDissolve
        self.present(loginVC!, animated: true, completion: nil)
    }

}
