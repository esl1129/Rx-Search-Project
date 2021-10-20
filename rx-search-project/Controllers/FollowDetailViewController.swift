//
//  DetailFollowViewController.swift
//  rx-search-project
//
//  Created by 임재욱 on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa

class FollowDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = RepositoryViewModel()
    var titleText: String = ""
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleText = title!
        
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "repoCell")) { _, repository, cell in
                cell.textLabel?.text = repository.repoName
                cell.detailTextLabel?.text = repository.repoURL
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: {user in
                guard let url = URL(string: user.repoURL) else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: disposeBag)
    }
}
