//
//  PetIds.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-21.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation

struct PetId {
    private var _id: String
    private var _name: String
    private var _type: String

    var id: String {
        set { _id = newValue }
        get { return _id }
    }

    var name: String {
        set { _name = newValue }
        get { return _name }
    }

    var type: String {
        set { _type = newValue }
        get { return _type }
    }

    init(_ id: String, _ name: String, _ type: String) {
        self._id = id
        self._name = name
        self._type = type
    }
}
