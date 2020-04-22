//
//  Meal.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-14.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import Foundation

struct Meal {
    private var name: String
    private var type: String
    private var isFed: Bool
    private var description: String
    
    init(_with name: String, _with type: String) {
        self.name = name
        self.type = type
        self.isFed = false
        self.description = ""
    }
}
