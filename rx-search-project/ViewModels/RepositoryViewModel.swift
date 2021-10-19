//
//  RepositoryViewModel.swift
//  searchProject
//
//  Created by 임재욱 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryViewModel{
    lazy var searchText = BehaviorRelay<String>(value: "My Initial Text")

    lazy var data: Driver<[Repository]> = {
        
        return self.searchText.asObservable()
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(RepositoryViewModel.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
}

// MARK: - APIManager
extension RepositoryViewModel{
    static func repositoriesBy(_ githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .retry(3)
        //.catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                  let repoURL = $0["html_url"] as? String else {
                      return
                  }
            repositories.append(Repository(repoName: repoName, repoURL: repoURL))
        }
        return repositories
    }
}
