//
//  User.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-01.
//

import Foundation


class UserProfile {
    static let shared = UserProfile()

    struct GeneralProfile {
        var id: String?
        var name: String?
        var email: String?
        var username: String?
        var token: String?
    }

    struct SettingsProfile {
        var notification: Bool? = true
        var faceId: Bool? = false
        var haptic: Bool? = true
    }

    var generalProfile = GeneralProfile()
    var settingsProfile = SettingsProfile()

    var isDetailsAvailable: Bool {
        return generalProfile.id != nil &&
               generalProfile.name != nil &&
               generalProfile.email != nil &&
               generalProfile.username != nil &&
               generalProfile.token != nil
    }

    private init() {
        loadUserData()
        loadUserSettings()
    }

    private func loadUserData() {
        let defaults = UserDefaults.standard
        generalProfile.id = defaults.string(forKey: "userId")
        generalProfile.name = defaults.string(forKey: "userName")
        generalProfile.email = defaults.string(forKey: "userEmail")
        generalProfile.username = defaults.string(forKey: "userUsername")
        generalProfile.token = defaults.string(forKey: "token")
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
        generalProfile.username = nil
        generalProfile.token = nil

        settingsProfile.notification = nil
        settingsProfile.faceId = nil
        settingsProfile.haptic = nil

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "userName")
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userUsername")
        defaults.removeObject(forKey: "token")
        defaults.removeObject(forKey: "notification")
        defaults.removeObject(forKey: "faceId")
        defaults.removeObject(forKey: "theme")
        defaults.removeObject(forKey: "haptic")
    }
}
