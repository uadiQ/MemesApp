//
//  LoginViewController.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 31.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var upperView: UIView!
    @IBOutlet private weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        setupGestures()
        fillTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillTextField()
    }
    
    private func fillTextField() {
        loginTextField.text = DataManager.instance.email ?? ""
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        upSwipeGesture.direction = .up
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(upSwipeGesture)
        self.view.addGestureRecognizer(downSwipeGesture)
    }
    
    @objc private func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    
    @objc private func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        hideKeyboard()
    }
    
    private func showErrorAlertWithOk(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func loginButtonPushed(_ sender: Any) {
        guard let email = loginTextField.text else { return }
        guard !email.isEmpty else {
            showErrorAlertWithOk(title: "Error", message: "Enter your email to log in")
            return
        }
        
        guard email.contains("@") else {
            showErrorAlertWithOk(title: "Error", message: "Incorrect email format")
            return
        }
        DataManager.instance.setEmail(with: email)
        hideKeyboard()
        performSegue(withIdentifier: "showMainScreen", sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}
