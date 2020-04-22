//
//  DataService.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-19.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import Foundation
import Firebase

// Gets base URL of Firebase database
let DB_BASE = Database.database().reference()

class DataService {
    static var instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_PET_INFO = DB_BASE.child("petInfo")
    private var _REF_MEALS = DB_BASE.child("meals")
    private var _REF_MEAL_MEMBERS = DB_BASE.child("mealMembers")
    private var _petIds = Set<String>()
    
    var REF_BASE: DatabaseReference { return _REF_BASE }
    var REF_USERS: DatabaseReference { return _REF_USERS }
    var REF_PET_INFO: DatabaseReference { return _REF_PET_INFO }
    var REF_MEALS: DatabaseReference { return _REF_MEALS }
    var REF_PET_MEAL_MEMBERS: DatabaseReference { return _REF_MEAL_MEMBERS }
    var petIds: Set<String> {
        set { _petIds = newValue }
        get { return _petIds }
    }

    // Brute force method of checking if a petId exists already on firebase...
    func downloadPetIds() {
        REF_PET_INFO.observeSingleEvent(of: .value) { (petInfoSnapshot) in
            guard let petInfoSnapshot = petInfoSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for petInfo in petInfoSnapshot {
                let id = petInfo.key
                self.petIds.insert(id)
                print(id)
            }
        }
    }

    func updatePetInfo(petId: String, petData: Dictionary<String,Any>) {
        var isIdUnique = false
        var currentId = petId
        while (!isIdUnique) {
            if DataService.instance.petIds.contains(currentId) {
                currentId = Device.randomString()
            } else {
                isIdUnique = true
            }
        }
        REF_PET_INFO.child(currentId).updateChildValues(petData)
    }

    func updateUser(uid: String, userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
