//
//  RefreshManager.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-08.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation
import Firebase


// Complicated method, will have to spend some time thinking about this...


//class RefreshManager: NSObject {
//
//    static let shared = RefreshManager()
//    private let defaults = UserDefaults.standard
//    private let defaultsKey = "lastRefresh"
//    private let calender = Calendar.current
//
//    func loadDataIfNeeded(completion: (Bool) -> Void) {
//
//        if isRefreshRequired() {
//            // We set all the meals "isFed" property to false
//            // Problem is different users may have different time zones which can effect other schedules...
//
//            // Temporary fix: lets just fresh the current pets meal plan since it is the most used one
//            // 1. get all meal names for current pet
//            DataService.instance.retrieveCurrentPet(forUid: Auth.auth().currentUser!.uid) { (petId) in
//                DataService.instance.retrieveAllMealsForPet(petId) { (allMeals) in
//                    // 2. update each meal name's isFed status to false
//                    let group = DispatchGroup()
//                    for (key, _) in allMeals {
//                        group.enter()
//                        DataService.instance.updatePetMeals(withPetId: petId, withMealName: key, andMealData: ["isFed": "false"]) {
//                            group.leave()
//                        }
//                    }
//                    group.notify(queue: .main) {
//
//                    }
//                }
//            }
//            defaults.set(Date(), forKey: defaultsKey)
//            completion(true)
//        } else {
//            completion(false)
//        }
//    }
//
//    private func isRefreshRequired() -> Bool {
//
//        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
//            return true
//        }
//
//        if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
//            return true
//        } else {
//            return false
//        }
//    }
//}
