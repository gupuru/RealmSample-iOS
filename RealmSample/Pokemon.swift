//
//  Pokemon.swift
//  RealmSample
//
//  Created by 新見晃平 on 2016/03/10.
//  Copyright © 2016年 kohei. All rights reserved.
//

import RealmSwift

// Pokemon model
class Pokemon: Object {
    
    dynamic var name: String = ""
    dynamic var height: Float = 0.0
    dynamic var weight: Float = 0.0
    dynamic var type: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
