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
import RappleProgressHUD


class FollowViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    let disposeBag = DisposeBag()
    var viewModel = FollowViewModel()
    let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.apple, tintColor: .white, screenBG: UIColor(white: 0.0, alpha: 0.5) ,thickness: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: attributes)
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
        
        tableView.rx.modelSelected(Follow.self)
            .subscribe(onNext: {follow in
                guard let url = URL(string: follow.pageUrl) else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: disposeBag)
        RappleActivityIndicatorView.stopAnimation(completionIndicator: .success, completionLabel: "Completed", completionTimeout: 2.0)
    }
}



