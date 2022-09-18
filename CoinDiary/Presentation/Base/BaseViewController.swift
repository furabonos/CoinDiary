//
//  BaseViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/15.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    func setupUI() {}
    func setupConstraints() {}
    func bind() {}

}
