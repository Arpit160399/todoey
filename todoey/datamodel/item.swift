//
//  item.swift
//  todoey
//
//  Created by Arpit Singh on 09/07/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import Foundation
import RealmSwift
class item : Object {
@objc dynamic var title = ""
    @objc dynamic var  done = false
    @objc dynamic var date : Date?
    var category = LinkingObjects(fromType: categories.self, property: "items")
    }
