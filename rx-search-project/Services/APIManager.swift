//
//  APIManager.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import Foundation
import RxSwift
import RxCocoa

final class APIManager{
    static let shared = APIManager()
}


// MARK: Load Repository By Id
extension APIManager{
    public func repositoriesBy(_ githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .retry(3)
        //.catchErrorJustReturn([])
            .map(parseRepo)
    }
    public func parseRepo(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        var repositories = [Repository]()
        
        items.forEach{
            guard let ownerdata = $0["owner"] as? [String:Any],
                  let ownername = ownerdata["login"] as? String,
                  let repoName = $0["name"] as? String,
                  let repoURL = $0["html_url"] as? String else {
                      return
                  }
            repositories.append(Repository(ownername, repoName, repoURL))
        }
        return repositories
    }
}


// MARK: Load Followings By Id
extension APIManager{
    public func followingsBy(_ githubID: String) -> Observable<[Follow]> {
        guard !githubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(githubID)/following") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .retry(3)
        //.catchErrorJustReturn([])
            .map(parseFollowing)
    }
    public func parseFollowing(json: Any) -> [Follow] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        var follows = [Follow]()
        items.forEach{
            guard let name = $0["login"] as? String,
                  let pageUrl = $0["html_url"] as? String else {
                      return
                  }
            follows.append(Follow(name, pageUrl))
        }
        return follows
    }
}
