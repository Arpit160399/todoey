//
//  categories.swift
//  todoey
//
//  Created by Arpit Singh on 09/07/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import Foundation
import RealmSwift
class categories: Object {
  @objc dynamic var name = ""
    @objc dynamic var colour = ""
    let items = List<item>()
}
