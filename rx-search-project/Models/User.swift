//
//  User.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import Foundation

struct User {
    
    let email: String
    let password: String
    let favorite: [String]
    var safeEmail: String{
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    init(_ email: String, _ password: String, _ favorite: [String]){
        self.email = email
        self.password = password
        self.favorite = favorite
    }
}
