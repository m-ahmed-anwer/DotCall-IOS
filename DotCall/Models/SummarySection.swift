//
//  SummarySection.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-15.
//


enum SummarySection: Int, CaseIterable, CustomStringConvertible{
    case Recording
    case Transcription
    case Summary
    case Participants
    
    var description: String{
        switch self{
            case .Recording: return "Recording"
            case .Transcription: return "Transcription"
            case .Summary: return "Summary"
            case .Participants: return "Participants"
        }
    }
}




enum RecordingOptions : Int, CaseIterable {
    case name
    case email
    case phoneNumber

  
    
    var description: String{
        switch self{
            case .name: return "Name"
            case .email: return "Email"
            case .phoneNumber: return "Phone Number"
           
        }
    }
   
    
}


enum TranscriptionOptions : Int, CaseIterable{
    case time
    case text
    case person
    
    var description: String{
        return ""
    }
  
}


enum SummaryOptions : Int, CaseIterable{

    case title
    case summary
  
    
    var description: String{
        return ""
    }
}

enum ParticipantOptions : Int, CaseIterable{

    case usercontact
    
    
    var description: String{
        return ""
    }
    
}


