//
//  CallClass.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-07-02.
//

import Foundation

class CallClass {
    
    var objectId: String
    var callerId: String
    var callerFullName: String
    var withUserFullName: String
    var withUserId: String
    var status: String
    var isIncoming: Bool
    var callDate: Date
    
    init(_callerId: String, _withUserId: String, _callerFullName: String, _withUserFullName: String) {
        
        objectId = UUID().uuidString
        callerId = _callerId
        callerFullName = _callerFullName
        withUserFullName = _withUserFullName
        withUserId = _withUserId
        status = ""
        isIncoming = false
        callDate = Date()
    }
    
    
    func dictionaryFromCall() {
        
    }
    
    //MARK: Save
    func saveCallInBackground() {

    }
    
    
    //MARK: Delete
    
    func deleteCall() {
    }


    
    
    
}
