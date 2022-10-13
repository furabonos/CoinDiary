//
//  CoinViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/13.
//

import UIKit
import Combine
import SnapKit
import DropDown

class CoinViewController: BaseViewController {
    
    public var viewModel: CoinViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: CoinViewModel) -> CoinViewController {
        let view = CoinViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }

}
