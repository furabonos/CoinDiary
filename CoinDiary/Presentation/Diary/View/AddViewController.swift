//
//  AddViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import UIKit
import SnapKit
import Combine

class AddViewController: BaseViewController {
    
    public var viewModel: AddViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: AddViewModel) -> AddViewController {
        let view = AddViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        //입력할것 시작금액 종료금액 메모 사진 날짜는 자동세팅
    }

}
