//
//  SummaryUser.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-05.
//

import Foundation
import RealmSwift

class SummaryUser: Object {
    @objc dynamic var callReciverName: String = ""
    @objc dynamic var callReciverUsername: String = ""
    @objc dynamic var recentSummary: String = ""
    @objc dynamic var recentTime: Date?
    let summary = List<Summary>()
}
