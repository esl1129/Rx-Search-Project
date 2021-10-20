//
//  DatabaseManager.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import RxSwift
import RxCocoa

final class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}
public enum DatabaseErrors: Error{
    case failedToFetch
}
extension DatabaseManager{
    public func safeEmail(with email: String) -> String{
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    public func makeEmailtoId(with email: String) -> String{
        let safe = email.split(separator: "@")
        return String(safe[0])
    }
}

extension DatabaseManager{
    /// Exists User
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)){
        let safeEmail = safeEmail(with: email)
        database.child("users/\(safeEmail)").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String:Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with email: String,githubId: String, completion: @escaping (Bool) -> Void){
        let safeEmail = safeEmail(with: email)
        let newElement = [
            "email":email,
            "userId":githubId
        ] as [String : Any]
        
        self.database.child("users/\(safeEmail)").setValue(newElement,withCompletionBlock: { error, _ in
            guard error == nil else{
                print("Failed to write to database")
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Get All Users in Firebase (for Conversation in NewConversationsViewController)
    public func getUserId(with email: String, completion: @escaping (Result<String, Error>) -> Void){
        let safeEmail = safeEmail(with: email)
        database.child("users/\(safeEmail)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: String] else{
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            completion(.success(value["userId"]!))
        })
    }
}

