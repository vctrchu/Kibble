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
    private var _REF_PET_MEALS = DB_BASE.child("petMeals")
    private var _REF_PET_DEFAULT_MEALS = DB_BASE.child("petDefaultMeals")
    private var _REF_PET_MEMBERS = DB_BASE.child("petMembers")

    var REF_BASE: DatabaseReference { return _REF_BASE }
    var REF_USERS: DatabaseReference { return _REF_USERS }
    var REF_PET_INFO: DatabaseReference { return _REF_PET_INFO }
    var REF_PET_MEALS: DatabaseReference { return _REF_PET_MEALS }
    var REF_PET_DEFAULT_MEALS: DatabaseReference { return _REF_PET_DEFAULT_MEALS }
    var REF_PET_MEMBERS: DatabaseReference { return _REF_PET_MEMBERS }

    func setup() {
        let data: Dictionary<String,Any> = ["Test":"Test"]
        //REF_PET_NOTIFICTAIONS.child("Configure").updateChildValues(data)
        //REF_PET_MEMBERS.child("Configure").updateChildValues(data)
        //REF_PET_MEALS.child("Configure").updateChildValues(data)
        REF_PET_DEFAULT_MEALS.child("CONFIGURE").updateChildValues(data)
    }

    /*
     Brute force: checking if a petId exists already on firebase
     Time and space compleixty: O(n)
     This is not good because as n gets large we are storing all these into our app memory which we will never use besides to check if a petId exists.
     Possible fix I can think of: Remove all unused elements from dictionary except the ones associated with the current user.
     */
    func downloadPetIds() {
        REF_PET_INFO.observeSingleEvent(of: .value) { (petInfoSnapshot) in

            guard let petInfoSnapshot = petInfoSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for petInfo in petInfoSnapshot {
                let id = petInfo.key
                guard let name = petInfo.childSnapshot(forPath: "name").value as? String else { continue }
                guard let type = petInfo.childSnapshot(forPath: "type").value as? String else { continue }
                let petId = PetId(id, name, type)
                LocalStorage.instance.petIds[id] = petId
                print(LocalStorage.instance.petIds[id]!)
            }
        }
    }

    func updatePetInfo(withPetId petId: String, andPetData petData: Dictionary<String,Any>) {
        var isIdUnique = false
        var currentId = petId
        // Time Complexity: O(n)
        // Worst case we reproduce the same random string n times...
        while (!isIdUnique) {
            if LocalStorage.instance.petIds.keys.contains(currentId) {
                currentId = Device.randomString()
            } else {
                isIdUnique = true
            }
        }
        REF_PET_INFO.child(currentId).updateChildValues(petData)
        let petId = PetId(currentId, petData["name"] as! String, petData["type"] as! String)
        LocalStorage.instance.petIds[currentId] = petId
    }

    func updateUser(withUid uid: String, withUserData userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }

    func addPetToUser(forUid uid: String, withPetId petId: String) {
        REF_USERS.child("\(uid)/pets").updateChildValues([petId: true as Any])
    }

    func updatePetMeals(withPetId petId: String, withMealName mealName: String, andMealData mealData: Dictionary<String,Any>, handler: @escaping () -> ()) {
        REF_PET_MEALS.child("\(petId)/\(mealName)").updateChildValues(mealData) { (error, snapshot) in
            handler()
        }
    }

    func updateDefaultPetMeals(withPetId petId: String, withMealName mealName: String, andMealData mealData: Dictionary<String,Any>, handler: @escaping () -> ()) {
        REF_PET_DEFAULT_MEALS.child("\(petId)/\(mealName)").updateChildValues(mealData) { (error, snapshot) in
            handler()
        }
    }

    func updatePetMealNotifications(withPetId petId: String, withMealName mealName: String, andNotificationData notificationData: Dictionary<String,Any>, handler: @escaping () -> ()) {
        REF_PET_MEALS.child("\(petId)/\(mealName)").updateChildValues(notificationData) { (error, snapshot) in
            handler()
        }
    }

    func updateDefaultPetMealNotifications(withPetId petId: String, withMealName mealName: String, andNotificationData notificationData: Dictionary<String,Any>, handler: @escaping () -> ()) {
           REF_PET_DEFAULT_MEALS.child("\(petId)/\(mealName)").updateChildValues(notificationData) { (error, snapshot) in
               handler()
           }
       }

    func updatePetMembers(withPetId petId: String, andMemberData memberData: Dictionary<String,Any>) {
        REF_PET_MEMBERS.child(petId).updateChildValues(memberData)
    }

    func retrieveUserFullName(withUid uid: String, handler: @escaping (_ fullname: String) -> ()) {
        REF_USERS.child("\(uid)/fullName").observeSingleEvent(of: .value) { (fullNameSnapShot) in
            let fullName = fullNameSnapShot.value as! String
            handler(fullName)
        }
    }

    func retrieveAllUserInfo(withUid uid: String, handler: @escaping () -> ()) {
         REF_USERS.child(uid).observe(.value) { (userSnapShot) in
            guard let userDict = userSnapShot.value as? [String : Any] else {
                print("Could not retrieve user info")
                return
            }
            LocalStorage.instance.currentUser = User(withId: uid,
                                                     withName: userDict["fullName"] as! String,
                                                     withEmail: userDict["email"] as! String,
                                                     withCurrentPet: userDict["currentPet"] as! String,
                                                     withPets: userDict["pets"] as! Dictionary<String,Any>)
            handler()
        }
    }


    func retrieveCurrentPet(forUid uid: String, handler: @escaping (_ currentPet: String) -> ()) {
        REF_USERS.child("\(uid)/currentPet").observe(.value) { (currentPetSnapshot) in
            let currentPetId = currentPetSnapshot.value as! String
            handler(currentPetId)
        }
    }

    func retrieveAllPetsForUser(withUid uid: String) {
        REF_USERS.child("\(uid)/pets").observe(.value) { (petSnapshot) in
            guard let dict = petSnapshot.value as? [String:Any] else {
                print("Could not retrive all pets for user")
                return
            }
            LocalStorage.instance.userAllPets = dict
        }
    }

    func retrieveAllPetMeals(forPetId petId: String, handler: @escaping (_ currentPet: [Meal]) -> ()) {
        var petMeals = [Meal]()
        REF_PET_MEALS.child(petId).observeSingleEvent(of: .value) { (mealSnapshot) in
            let meals = mealSnapshot.children
            for meal in meals {
                let mealSnap = meal as! DataSnapshot
                guard let dict = mealSnap.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let name = mealSnap.key
                let isFed = dict["isFed"] as! String
                let type = dict["type"] as! String
                var notification = "none"
                if let tempNotif = dict["notification"] {
                    notification = tempNotif as! String
                }
                print(name)
                print(isFed)
                print(type)
                print(notification)
                print("*****")
                let newMeal = Meal(name: name, type: type, isFed: isFed, notification: notification)
                petMeals.append(newMeal)
            }
            handler(petMeals)
        }
    }

    func deleteMeal(id: String, mealName: String, handler: @escaping () -> ()) {
        REF_PET_MEALS.child(id).child(mealName).removeValue { (error, snapshot) in
            handler()
        }
    }

    func deleteDefaultMeal(petId: String, mealName: String, handler: @escaping () -> ()) {
        REF_PET_DEFAULT_MEALS.child(petId).removeValue { (error, snapshot) in
            handler()
        }
    }
}
