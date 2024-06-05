//
//  Friend.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-05.
//

import Foundation
import RealmSwift

class Friend: Object {
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
}
