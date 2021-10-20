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
            .flatMapLatest(APIManager.shared.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
}
