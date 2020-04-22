//
//  PetIds.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-21.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation

struct PetId {
    private var id: String
    private var name: String
    private var type: String

    init(_ id: String, _ name: String, _ type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
}
