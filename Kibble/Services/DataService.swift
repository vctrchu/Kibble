//
//  DataService.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-19.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

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

    private var petIds = Dictionary<String,Pet>()

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
                let newPet = Pet(id, name, type, nil)
                self.petIds[id] = newPet
                print(self.petIds[id])
            }
        }
    }

    func createPetInfo(withPetId petId: String, andPetData petData: Dictionary<String,Any>) {
        var isIdUnique = false
        var currentId = petId
        // Time Complexity: O(n)
        // Worst case we reproduce the same random string n times...
        while (!isIdUnique) {
            if petIds.keys.contains(currentId) {
                currentId = Device.randomString()
            } else {
                isIdUnique = true
            }
        }
        REF_PET_INFO.child(currentId).updateChildValues(petData)
    }

    // MARK: - Update Methods

    func updatePetInfo(_ petId: String, andPetData petData: Dictionary<String,Any>) {
        REF_PET_INFO.child(petId).updateChildValues(petData)
    }

    func updateUser(withUid uid: String, withUserData userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }

    func updateUserCompletion(_ uid: String, _ userData: Dictionary<String,Any>, completion: @escaping(() -> ())) {
        REF_USERS.child(uid).updateChildValues(userData) { (erro, snapshot) in
            completion()
        }
    }

    func addPetToUser(forUid uid: String, withPetId petId: String) {
        REF_USERS.child("\(uid)/pets").updateChildValues([petId: true as Any])
    }

    func updatePetMeals(withPetId petId: String, withMealName mealName: String, andMealData mealData: Dictionary<String,Any>, handler: @escaping () -> ()) {
        REF_PET_MEALS.child("\(petId)/\(mealName)").updateChildValues(mealData) { (error, snapshot) in
            handler()
        }
    }

    func updateAllPetMeals(_ petId: String, mealData: Dictionary<String,Any>, completion: @escaping () -> ()) {
        REF_PET_MEALS.child(petId).updateChildValues(mealData) { (error, snapshot) in
            completion()
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

    func updatePetPhoto(_ userUid: String,_ image: UIImage, completion: @escaping ((_ url: URL) -> ())) {
        let storageRef = Storage.storage().reference().child("user/\(userUid)")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                print(error)
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Failed to download url:", error!)
                    return
                } else {
                    completion(url!)
                }

            })
        }
    }

    // MARK: - Retrieval Methods

    func retrieveUserFullName(withUid uid: String, handler: @escaping (_ fullname: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                print("Could not retrieve full name")
                return
            }
            let fullName = dict["fullName"] as! String
            handler(fullName)
        }
    }

    func retrieveAllUserInfo(withUid uid: String, handler: @escaping () -> ()) {
        REF_USERS.child(uid).observe(.value) { (userSnapShot) in
            guard let userDict = userSnapShot.value as? [String : Any] else {
                print("Could not retrieve user info")
                return
            }
            handler()
        }
    }

    func retrieveCurrentPet(forUid uid: String, handler: @escaping (_ currentPet: String?) -> ()) {
        REF_USERS.child("\(uid)/currentPet").observe(.value) { (currentPetSnapshot) in
            if let currentPetId = currentPetSnapshot.value as? String {
                handler(currentPetId)
            } else {
                handler(nil)
            }
        }
    }

    func retrieveDefaultPetMeal(_ petId: String, completion: @escaping (_ defaultMeal: [String: Any]) -> ()) {
        REF_PET_DEFAULT_MEALS.child(petId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                print("Could not retrieve default pet meal")
                return
            }
            completion(dict)
        }
    }

    func retrieveAllPetsForUser(withUid uid: String, completion: @escaping (_ currentPet: [String: Any]) -> ()) {
        REF_USERS.child("\(uid)/pets").observe(.value) { (petSnapshot) in
            guard let dict = petSnapshot.value as? [String:Any] else {
                print("Could not retrive all pets for user")
                return
            }
            completion(dict)
        }
    }

    func retrieveAllMealsForPet(_ petId: String, completion: @escaping (_ currentPet: [String: Any]) -> ()) {
        REF_PET_MEALS.child((petId)).observe(.value) { (petSnapshot) in
            guard let dict = petSnapshot.value as? [String:Any] else {
                print("Could not retrive all meals for pet")
                return
            }
            completion(dict)
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

    func retrieveMembers(forPetId petId: String, handler: @escaping (_ members: [String:Any]) -> ()) {
        REF_PET_MEMBERS.child(petId).observe(.value) { (memberSnapshot) in
            guard let dict = memberSnapshot.value as? [String:Any] else {
                print("Could not retreive members for pet id")
                return
            }
            handler(dict)
        }
    }

    func retrievePet(_ petId: String, completion: @escaping (_ pet: Pet?) -> ()) {
        REF_PET_INFO.child(petId).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let name = dict["name"] as! String
                let type = dict["type"] as! String
                let url = dict["photoUrl"] as? String
                let newPet = Pet(petId, name, type, url)
                completion(newPet)
            } else {
                completion(nil)
            }
        }
    }

    func retrieveAllMemberNames(forPetId petId: String, handler: @escaping (_ names: [String]) -> ()) {
        var namesArray = [String]()
        REF_PET_MEMBERS.child(petId).observeSingleEvent(of: .value) { (snapshot) in
            let names = snapshot.children
            for name in names {
                let nameSnap = name as! DataSnapshot
                let name = nameSnap.value as! String
                namesArray.append(name)
            }
            handler(namesArray)
        }
    }

    // MARK: - Delete Methods

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
