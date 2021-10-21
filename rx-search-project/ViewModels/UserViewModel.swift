//
//  UserViewModel.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel{
    lazy var username = BehaviorRelay<String>(value: "My Initial Text")

}
