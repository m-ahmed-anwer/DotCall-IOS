//
//  User.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-01.
//

import Foundation


    
var userEmail: String = ""
var userName: String = ""
var userPhoneNumber: String = ""
var userCreatedAt: String = ""
var userPassword: String = ""



class UserProfile {
    static let shared = UserProfile()

    struct GeneralProfile {
        var id: String?
        var name: String?
        var email: String?
        var phoneNumber: String?
    }

    struct SettingsProfile {
        var notification: Bool? = true
        var faceId: Bool? = false
        var haptic: Bool? = true
    }

    var generalProfile = GeneralProfile()
    var settingsProfile = SettingsProfile()

    private init() {
        loadUserData()
        loadUserSettings()
    }

    private func loadUserData() {
        let defaults = UserDefaults.standard
        generalProfile.id = defaults.string(forKey: "userId")
        generalProfile.name = defaults.string(forKey: "userName")
        generalProfile.email = defaults.string(forKey: "userEmail")
        generalProfile.phoneNumber = defaults.string(forKey: "userPhoneNumber")
    }
    
    private func loadUserSettings() {
        let defaults = UserDefaults.standard
        settingsProfile.notification = defaults.bool(forKey: "notification")
        settingsProfile.faceId = defaults.bool(forKey: "faceId")
        settingsProfile.haptic = defaults.bool(forKey: "haptic")
    }
    
    func logOut() {
        generalProfile.id = nil
        generalProfile.name = nil
        generalProfile.email = nil
        generalProfile.phoneNumber = nil

        settingsProfile.notification = nil
        settingsProfile.faceId = nil
        settingsProfile.haptic = nil

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "userName")
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userPhoneNumber")
        defaults.removeObject(forKey: "notification")
        defaults.removeObject(forKey: "faceId")
        defaults.removeObject(forKey: "theme")
        defaults.removeObject(forKey: "haptic")
    }
}
