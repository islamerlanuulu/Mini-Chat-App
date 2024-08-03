//
//  BaseViewController.swift
//  ChatApp
//
//  Created by @islamien  on 3/8/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func setup() {
        view.backgroundColor = .systemBackground
        setupSubViews()
        setupConstraints()
    }
    
    public func setupSubViews() {}
    
    public func setupConstraints() {}
    
}
