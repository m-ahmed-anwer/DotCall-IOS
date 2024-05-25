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
    case email
    case phoneNumber

    var containSwitch: Bool {
        return false
    }

    var description: String {
        switch self {
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

// MARK: - Public General Options Enum
enum PublicGeneralnOptions: Int, CaseIterable, PublicSectionType {
    case record

    var containSwitch: Bool {
        switch self {
        case .record: return true
        }
    }

    var description: String {
        switch self {
        case .record: return "Allow Record"
        }
    }

    var imageName: String {
        switch self {
        case .record: return "waveform.badge.mic"
        }
    }
}
