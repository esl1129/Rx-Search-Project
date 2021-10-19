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
    private var loginObserver: NSObjectProtocol?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        guard let email = emailField.text, let password = passwordField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let strongSelf = self else { return }
            if (success) {
                strongSelf.navigationController?.dismiss(animated: true)
            } else {
                print("There was an error.")
            }
        }
    }
}

// MARK: - Init
extension LoginViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
}
