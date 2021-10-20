//
//  User.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/20.
//

import Foundation

struct User {
    let name: String
    let pageUrl: String
    
    init(_ name: String, _ url: String){
        self.name = name
        self.pageUrl = url
    }
}
