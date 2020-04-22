//
//  AuthService.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-04.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation
import Firebase

class AuthService {

    static var instance = AuthService()

    func registerUser(fullName: String, withEmail email: String, andPassword password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            let userData = ["email": user.email, "fullname": fullName]
            DataService.instance.updateUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    


    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }

}
