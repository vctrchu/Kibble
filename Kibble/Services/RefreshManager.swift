//
//  RefreshManager.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-08.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

//import Foundation
//import Firebase


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
