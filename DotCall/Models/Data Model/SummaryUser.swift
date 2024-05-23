//
//  SummaryUser.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-22.
//

import Foundation
import RealmSwift

class SummaryUser: Object {
    @objc dynamic var callReciverName: String = ""
    @objc dynamic var callReciverPhoneNum: String = ""
    @objc dynamic var recentSummary: String = ""
    @objc dynamic var recentTime: Date?
    let summary = List<Summary>()
}
