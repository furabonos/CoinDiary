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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize.height = 10
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
//        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        cv.backgroundColor = .white
//        cv.delegate = self
//        cv.dataSource = self
//        cv.register(UserListCell.self, forCellWithReuseIdentifier: self.userListCell)
        return cv
    }()
    
    lazy var addBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "plus"), for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 30
        b.layer.shadowColor = UIColor.gray.cgColor
        b.layer.shadowOpacity = 1.0
        b.layer.shadowOffset = CGSize.zero
        b.layer.shadowRadius = 6
        return b
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
        [menuStackView, collectionView, addBtn].forEach { self.view.addSubview($0) }
        makeMenuStackView()
    }
    
    override func setupConstraints() {
        menuStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(menuStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
