//
//  RegisterViewController.swift
//  woogie-Messenger
//
//  Created by 임재욱 on 2021/10/03.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func registerButton(_ sender: Any) {
        let signUpManager = FirebaseAuthManager()
        if let email = emailField.text, let password = passwordField.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let strongSelf = self else { return }
                if (success) {
                    strongSelf.navigationController?.dismiss(animated: true)
                } else {
                    print("There was an error.")
                }
            }
        }
    }
}

// MARK: - Init
extension RegisterViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
}
