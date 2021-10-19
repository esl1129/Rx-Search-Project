//
//  UserViewModel.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import RxSwift
import RxRelay

class UserViewModel {
    let loginManager = AuthManager()
    lazy var emailObserver = BehaviorRelay<String>(value: "")
    lazy var passwordObserver = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map { email, password in
                return !email.isEmpty && email.contains("@") && email.contains(".") && password.count > 0
            }
    }
}
extension UserViewModel{
    /// Login User Firebase
    func loginUser(_ email: String, _ password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        loginManager.signIn(email: email, password: password) {success in
            if success {
                completionBlock(true)
            }else{
                completionBlock(false)
            }
        }
    }
    /// Create User Firebase
    func createUser(_ email: String, _ password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        loginManager.createUser(email: email, password: password) {success in
            if success {
                completionBlock(true)
            }else{
                completionBlock(false)
            }
        }
    }
}
