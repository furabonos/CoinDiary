//
//  DiaryViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit
import Combine
import SnapKit

class DiaryViewController: BaseViewController, Alertable {
    
    var menuStackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
//        sv.backgroundColor = Colors.iosGrey
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    public var viewModel: DiaryViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: DiaryViewModel) -> DiaryViewController {
        let view = DiaryViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    override func setupUI() {
        [menuStackView].forEach { self.view.addSubview($0) }
        makeMenuStackView()
    }
    
    override func setupConstraints() {
        menuStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    private func makeMenuStackView() {
        for i in 0..<viewModel.menuList.count {
            var menuLabel: UILabel = {
                var l = UILabel()
                l.text = viewModel.menuList[i]
//                l.textColor = .black
                l.textAlignment = .center
//                l.backgroundColor = Colors.iosGrey
                l.font = l.font.withSize(13)
                return l
            }()
            menuStackView.addArrangedSubview(menuLabel)
        }
    }

}
