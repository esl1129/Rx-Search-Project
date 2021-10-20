//
//  RegisterViewController.swift
//  woogie-Messenger
//
//  Created by 임재욱 on 2021/10/03.
//


import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    @IBOutlet weak var githubField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
}

// MARK: - Init
extension RegisterViewController{
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

extension RegisterViewController{
    func setUp() {
        emailField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        passwordField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid.bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: registerButton.rx.alpha)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(
            onNext: { [weak self] _ in
                guard let githubId = self?.githubField.text,
                    let email = self?.emailField.text,
                        let password = self?.passwordField.text
                else { return }
                guard let strongSelf = self else { return }
                strongSelf.viewModel.createUser(githubId, email, password){ success in
                    if success{
                        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
                        guard let uvc = storyboard?.instantiateViewController(identifier: "MainVC") else {
                            return
                        }
                        uvc.modalPresentationStyle = .fullScreen
                        strongSelf.present(uvc, animated: false)
                    }else{
                        print("RegisterViewController: Failed to SingUp")
                        
                    }
                }
            }).disposed(by: disposeBag)
    }
}
