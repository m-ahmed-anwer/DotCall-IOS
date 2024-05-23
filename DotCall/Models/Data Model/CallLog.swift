//
//  CallLog.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-22.
//

import Foundation
import RealmSwift

class CallLog: Object {
    @objc dynamic var callDuration: String = ""
    @objc dynamic var callName: String = ""
    @objc dynamic var callPhoneNum: String = ""
    @objc dynamic var callStatus: String = ""
    @objc dynamic var callTime: Date?
    @objc dynamic var callType: String = ""
}