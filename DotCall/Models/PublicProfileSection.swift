//
//  PublicProfileSection.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-12.
//

// MARK: - Public Section Type Protocol
protocol PublicSectionType: CustomStringConvertible {
    var containSwitch: Bool { get }
    var imageName: String { get }
}

// MARK: - Public Profile Section Enum
enum PublicProfileSection: Int, CaseIterable, CustomStringConvertible {
    case Image
    case ChatCall
    case Profile
    case General

    var description: String {
        switch self {
        case .Image: return ""
        case .ChatCall: return ""
        case .Profile: return "Profile"
        case .General: return "General"
        }
    }
}

// MARK: - Public Profile Options Enum
enum PublicProfileOptions: Int, CaseIterable, PublicSectionType {
    case name
    case username

    var containSwitch: Bool {
        return false
    }

    var description: String {
        switch self {
        case .name: return "Name"
        case .username: return "UserName"
        }
    }

    var imageName: String {
        switch self {
        case .name: return "person"
        case .username: return "key"
        }
    }
}

// MARK: - Public General Options Enum
enum PublicGeneralnOptions: Int, CaseIterable, PublicSectionType {
    case friendrecord
    case record
    

    var containSwitch: Bool {
        switch self {
        case .friendrecord: return true
        case .record: return true
        
        }
    }

    var description: String {
        switch self {
        case .friendrecord: return "Friend Acceptance"
        case .record: return "Allow Record"
        
        }
    }

    var imageName: String {
        switch self {
        case .friendrecord: return "waveform.badge.mic"
        case .record: return "waveform.badge.mic"
        
        }
    }
}
