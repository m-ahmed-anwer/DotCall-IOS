//
//  Summary.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-05.
//

import Foundation
import RealmSwift

class Summary: Object {
    @objc dynamic var callMakerEmail: String = ""
    @objc dynamic var callMakerName: String = ""
    @objc dynamic var callMakerUsername: String = ""
    @objc dynamic var callReciverEmail: String = ""
    @objc dynamic var callReciverName: String = ""
    @objc dynamic var callReciverUsername: String = ""
    @objc dynamic var summaryDetail: String = ""
    @objc dynamic var summaryTopic: String = ""
    @objc dynamic var time: Date?
    @objc dynamic var transcription: String = ""
    var parentSummary = LinkingObjects(fromType: SummaryUser.self, property: "summary")
}
