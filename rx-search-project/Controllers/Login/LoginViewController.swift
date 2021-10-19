//
//  LoginViewController.swift
//  woogie-Messenger
//
//  Created by 임재욱 on 2021/10/03.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let disposeBag = DisposeBag()
    let viewModel = UserViewModel()
}

// MARK: - Init
extension LoginViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUp()
    }
}

extension LoginViewController{
    func setUp() {
        // 1
        emailField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        // 2
        passwordField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        // 3
        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        // 4
        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        // 5
        loginButton.rx.tap.subscribe(
            onNext: { [weak self] _ in
                guard let email = self?.emailField.text, let password = self?.passwordField.text else { return }
                guard let strongSelf = self else { return }
                strongSelf.viewModel.loginUser(email, password){ success in
                    if success{
                        strongSelf.navigationController?.dismiss(animated: true)
                    }else{
                        print("LoginViewController: Failed to Login")
                        
                    }
                }
            }).disposed(by: disposeBag)
    }
}
