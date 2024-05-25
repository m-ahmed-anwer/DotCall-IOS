//
//  AuthManager.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-30.
//

import Foundation
import FirebaseAuth

class AuthManager {
    // MARK: - Properties
    static let shared = AuthManager()

    private let auth = Auth.auth()
    private var verificationId: String?

    // MARK: - Public Methods
    public func startAuth(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        // Disable app verification for testing
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true

        // Start phone number authentication
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            if let error = error {
                print("Error starting auth: \(error.localizedDescription)")
                completion(false, error) // Pass the error to the completion handler
                return
            }

            // Save the verification ID for later use
            self.verificationId = verificationId
            completion(true, nil)
        }
    }

    public func verifyCode(smsCode: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let verificationId = verificationId else {
            completion(false, NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Verification ID is missing"]))
            return
        }

        // Create a credential using the verification ID and SMS code
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)

        // Sign in with the credential
        auth.signIn(with: credential) { result, error in
            if let error = error {
                print("Error verifying code: \(error.localizedDescription)")
                completion(false, error) // Pass the error to the completion handler
                return
            }

            completion(true, nil)
        }
    }
}
