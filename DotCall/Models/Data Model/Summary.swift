//
//  Summary.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-22.
//

import Foundation
import RealmSwift

class Summary: Object {
    @objc dynamic var callMakerEmail: String = ""
    @objc dynamic var callMakerName: String = ""
    @objc dynamic var callMakerPhoneNum: String = ""
    @objc dynamic var callReciverEmail: String = ""
    @objc dynamic var callReciverName: String = ""
    @objc dynamic var callReciverPhoneNum: String = ""
    @objc dynamic var summaryDetail: String = ""
    @objc dynamic var summaryTopic: String = ""
    @objc dynamic var time: Date?
    @objc dynamic var transcription: String = ""
    var parentSummary = LinkingObjects(fromType: SummaryUser.self, property: "summary")
}
