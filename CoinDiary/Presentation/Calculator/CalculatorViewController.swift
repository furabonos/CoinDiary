//
//  CalculatorViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/20.
//

import UIKit
import Combine
import SnapKit

class CalculatorViewController: BaseViewController {
    
    lazy var buttonView: UIView = {
        var v = UIView()
        return v
    }()
    
    var scrollView: UIScrollView = {
        var sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .yellow
        return sv
    }()
    
    //target 목표가
    lazy var targetBtn: UIButton = {
        var b = UIButton()
        b.setTitle("목표가", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.textAlignment = .center
        return b
    }()
    
    var targetView: UIView = {
        var v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public var viewModel: CalculatorViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: CalculatorViewModel) -> CalculatorViewController {
        let view = CalculatorViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // 1.목표가 2.물타기 3.퍼센트
    }
    
    override func setupUI() {
        [buttonView, scrollView].forEach { self.view.addSubview($0) }
        [targetBtn].forEach { self.buttonView.addSubview($0) }
        [targetView].forEach { self.scrollView.addSubview($0) }
    }
    
    override func setupConstraints() {
        buttonView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(300)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        self.scrollView.contentSize = CGSize(width: Int(self.view.bounds.width) * 3, height: 0)
//        CGRect(x: Int(self.view.bounds.width) * i, y: 0, width: Int(self.view.bounds.width), height: 70)
        targetView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        
        targetBtn.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
    }

}
