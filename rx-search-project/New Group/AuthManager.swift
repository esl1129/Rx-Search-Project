//
//  AuthManager.swift
//  searchProject
//
//  Created by 임재욱 on 2021/10/19.
//

import Foundation
import FirebaseAuth

class AuthManager {
    /// Register
    func createUser(githubId: String, email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        DatabaseManager.shared.userExists(with: email, completion: {exists in
            guard !exists else{
                // user already exists
                print("User account for that email address already exists")
                completionBlock(false)
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult?.user {
                    DatabaseManager.shared.insertUser(with: user.email!,githubId: githubId, completion: {success in
                        if success{
                            completionBlock(true)
                            return
                        }
                    })
                }
            }
        })
        completionBlock(false)
    }
    /// Login
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
}


