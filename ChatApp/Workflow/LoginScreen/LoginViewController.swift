//
//  ViewController.swift
//  ChatApp
//
//  Created by @islamien  on 3/8/24.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "username..."
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.leftViewMode = .always
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemGreen
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white.withAlphaComponent(0.3), for: .highlighted)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.setTitle("Continue", for: .normal)
        view.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
        
        if ChatManager.shared.isSignedIn {
            presentChatList(animated: false)
        }
    }
    
    override func setup() {
        super.setup()
        navigationItem.title = "Chat"
    }
    
    override func setupSubViews() {
        super.setupSubViews()
        view.addSubview(usernameTextField)
        view.addSubview(continueButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            continueButton .heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func presentChatList(animated: Bool = true) {
        guard let vc = ChatManager.shared.createChannelList() else { return }
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                               target: self,
                                                               action: #selector(didTapCompose))
        
        let tabVc = TabBarController(chatList: vc)
        tabVc.modalPresentationStyle = .fullScreen
        
        present(tabVc, animated: animated)
    }
    
    @objc
    private func didTapContinue() {
        usernameTextField.resignFirstResponder()
        
        guard let text = usernameTextField.text, !text.isEmpty else { return }
        
        ChatManager.shared.signIn(with: text) { [weak self ] success in
            guard success else {
                return
            }
            
            print("Did Login")
            
            DispatchQueue.main.async {
                self?.presentChatList()
            }
        }
    }
    
    @objc
    private func didTapCompose() {
        let alert = UIAlertController(title: "New Chat",
                                      message: "Enter channel Name",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Create", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            
            DispatchQueue.main.async {
                ChatManager.shared.createNewChannel(name: text)

            }
        }))
        
        presentedViewController?.present(alert, animated: true)
    }
}

