//
//  ProfileViewController.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class ProfileViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - Setup
extension ProfileViewController{
    func setUp(){
        logoutButton.rx.tap.subscribe(
            onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                do {
                    try Auth.auth().signOut()
                    strongSelf.navigationController?.dismiss(animated: true)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }).disposed(by: disposeBag)
    }
}
