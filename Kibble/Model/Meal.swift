//
//  Meal.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-23.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation

struct Meal {
    private var _name: String
    private var _type: String
    private var _isFed: String

    var name: String {
        return _name
    }

    var type: String {
        return _type
    }

    var isFed: String {
        return _isFed
    }

    init(name: String, type: String, isFed: String) {
        self._name = name
        self._type = type
        self._isFed = isFed
    }
}
