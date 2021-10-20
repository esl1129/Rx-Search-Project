//
//  FollowViewController.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class FollowViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    let disposeBag = DisposeBag()
    var viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}


// MARK: - Initialize Setting
extension FollowViewController{
    func setUp(){
        let email = Auth.auth().currentUser!.email
        DatabaseManager.shared.getUserId(with: email!,completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result{
            case .success(let userId):
                strongSelf.nameField.text = userId
                strongSelf.settingRx()
            case .failure(let error):
                print("Failed to get users: \(error)")
            }
        })
    }
    func settingRx(){
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "followCell")) { _, user, cell in
                cell.textLabel?.text = user.name
                cell.detailTextLabel?.text = user.pageUrl
            }
            .disposed(by: disposeBag)
        nameField.rx.text.orEmpty
            .bind(to: viewModel.myname)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Following" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: {user in
                guard let url = URL(string: user.pageUrl) else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: disposeBag)
    }
}



