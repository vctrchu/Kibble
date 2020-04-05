//
//  User.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-04.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation
import Firebase

struct User {

    var fullName: String!
    var email: String!
    var photoUrl: String?
    var ref: DatabaseReference?
    var key: String?

    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        fullName = (snapshot.value! as! NSDictionary)["fullname"] as! String
        email = (snapshot.value! as! NSDictionary)["email"] as! String
    }
}
