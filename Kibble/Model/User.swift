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

    private var _id: String
    private var _name: String
    private var _email: String
    private var _currentPet: String
    private var _pets: Dictionary<String,Any>

    var id: String {
        set { _id = newValue }
        get { return _id }
    }

    var name: String {
        set { _name = newValue }
        get { return _name }
    }

    var email: String {
        set { _email = newValue }
        get { return _email }
    }

    var currentPet: String {
        set { _currentPet = newValue }
        get { return _currentPet }
    }

    var pets: Dictionary<String,Any> {
        set { _pets = newValue }
        get { return _pets }
    }

    init(withId id: String, withName name: String, withEmail email: String, withCurrentPet currentPet: String, withPets pets: Dictionary<String,Any>) {
        self._id = id
        self._name = name
        self._email = email
        self._currentPet = currentPet
        self._pets = pets
    }
}
