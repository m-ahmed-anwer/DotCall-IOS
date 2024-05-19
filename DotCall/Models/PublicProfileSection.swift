//
//  PublicProfileSection.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

protocol PublicSectionType: CustomStringConvertible{
    var containSwitch: Bool {get}
    var imageName: String { get } 
}



enum PublicProfileSection: Int, CaseIterable, CustomStringConvertible{
    case Image
    case ChatCall
    case Profile
    case General
    
    
    var description: String{
        switch self{
            case .Image: return ""
            case .ChatCall: return ""
            case .Profile: return "Profile"
            case .General: return "General"
        }
    }
}




enum PublicProfileOptions : Int, CaseIterable, PublicSectionType{
    case name
    case email
    case phoneNumber

    
    var containSwitch: Bool{
        return false
    }

    
    var description: String{
        switch self{
            case .name: return "Name"
            case .email: return "Email"
            case .phoneNumber: return "Phone Number"
           
        }
    }
    
    
    var imageName: String {
        switch self {
            case .name: return "person"
            case .email: return "envelope"
            case .phoneNumber: return "phone"
        }
    }
    
}


enum PublicGeneralnOptions : Int, CaseIterable, PublicSectionType{
    case record
    
    
    var containSwitch: Bool{
        switch self{
            case .record: return true
        }
    }
    
    var description: String{
        switch self{
            case .record: return "Allow Record"
        }
    }
    
    var imageName: String {
        switch self {
            case .record: return "waveform.badge.mic"
        }
    }
}


