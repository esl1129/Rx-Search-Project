//
//  UserViewModel.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class FollowViewModel{
    
    lazy var myname = BehaviorRelay<String>(value: "")
    lazy var data: Driver<[Follow]> = {
        return self.myname.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(APIManager.shared.followingsBy)
            .asDriver(onErrorJustReturn: [])
    }()
}
