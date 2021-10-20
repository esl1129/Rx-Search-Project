//
//  Repository.swift
//  searchProject
//
//  Created by 임재욱 on 2021/10/16.
//

struct Repository {
    let owner: String
    let repoName: String
    let repoURL: String
    
    init(_ owner: String, _ repositoryName: String, _ url: String){
        self.owner = owner
        self.repoName = repositoryName
        self.repoURL = url
    }
}
