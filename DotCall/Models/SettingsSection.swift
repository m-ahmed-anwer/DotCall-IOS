//
//  SettingsSection.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-09.
//


protocol SectionType: CustomStringConvertible{
    var containSwitch: Bool {get}
    var imageName: String { get }
    var id: Int { get }
}



enum SettingsSection: Int, CaseIterable, CustomStringConvertible{
    case Image
    case Profile
    case General
    case LogOut
    
    var description: String{
        switch self{
            case .Image: return ""
            case .Profile: return "Profile"
            case .General: return "General"
            case .LogOut: return ""
        }
    }
}




enum ProfileOptions : Int, CaseIterable, SectionType{
    case name
    case email
    case phoneNumber

    var id: Int{
        return 0
    }
    
   

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


enum GeneralnOptions : Int, CaseIterable, SectionType{
    case notification
    case faceId
    case haptic
    
    var id: Int{
        switch self{
            case .notification: return 0
            case .faceId: return 1
            case .haptic: return 2
        }
    }
    

    var containSwitch: Bool{
        switch self{
            case .notification: return true
            case .faceId: return true
            case .haptic: return true
        }
    }
    
    var description: String{
        switch self{
            case .notification: return "Notification"
            case .faceId: return "Face ID"
            case .haptic: return "Haptic Feedback"
        }
    }
    
    var imageName: String {
        switch self {
            case .notification: return "bell.badge"
            case .faceId: return "faceid"
            case .haptic: return "iphone.radiowaves.left.and.right"
        }
    }
}


enum LogOutOptions : Int, CaseIterable, SectionType{

    case logout
    
    
    
    var id: Int{
        return 0
    }
    
    var imageName: String{
        return ""
    }
    
    var containSwitch: Bool{
        return false
    }
    
    var description: String{
        switch self{
            case .logout: return "Log Out"
        }
    }
    
}
