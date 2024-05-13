//
//  CallManager.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//
import CallKit
import Foundation
import StreamVideo
import StreamVideoUIKit
import StreamVideoSwiftUI


class CallManager{

    
    static let shared = CallManager()
    
    struct Constants{
        static let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiUGxvX0tvb24iLCJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL1Bsb19Lb29uIiwiaWF0IjoxNzE1NTgwNTAwLCJleHAiOjE3MTYxODUzMDV9.8R7Doq2gvAnGdrmmIoeweVNirsXrgklq-ESUByQaiHc"
    }
    
    struct UserCredentials{
        let user: User
        let token: UserToken
    }
    
    func setUp(email:String){
        setUpCallViewModel()
        let userCredentials = UserCredentials(user: .guest(email), token: UserToken(rawValue: Constants.userToken))
        
        
    }
    
    
    private func setUpCallViewModel(){
        
    }
    
   
}
