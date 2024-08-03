//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by @islamien  on 3/8/24.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.font = .systemFont(ofSize: 22, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logOutButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white.withAlphaComponent(0.3), for: .highlighted)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.setTitle("Sign Out 💔", for: .normal)
        view.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setup() {
        super.setup()
        navigationItem.title = "Settings"
        
        setUpText()
    }
    
    override func setupSubViews() {
        super.setupSubViews()
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(logOutButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 80),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            
            logOutButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            logOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            logOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            logOutButton .heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setUpText() {
        usernameLabel.text = ChatManager.shared.currentUser
    }
    
    @objc
    private func didTapLogOut() {
        ChatManager.shared.signOut()
        
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
