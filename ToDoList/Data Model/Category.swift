//
//  Category.swift
//  ToDoList
//
//  Created by Kean Chin on 1/29/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
