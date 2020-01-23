//
//  RealmDataBase.swift
//  RealmExp
//
//  Created by Awais Ansari on 22/07/19.
//  Copyright © 2019 Tagrem. All rights reserved.
//

import Foundation
import RealmSwift


class Venue : Object {
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var address : String = ""
  //  @objc dynamic var image : String = ""
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var lng : Double = 0.0

    override static func primaryKey() -> String?{
        return "id"
    }
}





