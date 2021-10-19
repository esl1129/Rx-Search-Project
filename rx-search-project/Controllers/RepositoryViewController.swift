//
//  ViewController.swift
//  searchProject
//
//  Created by 임재욱 on 2021/10/16.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = RepositoryViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "repoCell")) { _, repository, cell in
                cell.textLabel?.text = repository.repoName
                cell.detailTextLabel?.text = repository.repoURL
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: {user in
                guard let url = URL(string: user.repoURL) else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let uvc = storyboard?.instantiateViewController(identifier: "LoginVC") else {
                return
            }
            uvc.modalPresentationStyle = .fullScreen
            self.present(uvc, animated: false)
        }
    }
}

