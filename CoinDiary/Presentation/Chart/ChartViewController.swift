//
//  ChartViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit
import Combine

class ChartViewController: UIViewController {
    
    public var viewModel: ChartViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: ChartViewModel) -> ChartViewController {
        let view = ChartViewController()
        view.viewModel = viewModel

        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        print("chart viewcontroller")
    }

}
