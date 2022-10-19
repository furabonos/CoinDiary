//
//  DiaryViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit
import Combine
import SnapKit
import Firebase
import FirebaseCore
import FirebaseStorage


class DiaryViewController: BaseViewController {
    
    lazy var menuStackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var diaryCell = "DiaryCell"
    enum Section {
        case main
    }
    typealias Item = DiaryEntity
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(DiaryCell.self, forCellWithReuseIdentifier: self.diaryCell)
        cv.delegate = self
        return cv
    }()
    
    lazy var addBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "plus"), for: .normal)
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 30
        b.addAllShadow()
        b.addTarget(self, action: #selector(clickAddBtn(_:)), for: .touchUpInside)
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
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if getStringUserDefaults(key: "unit") == "" {
            selectMoneyUnitAlert(title: "", message: "단위를 선택해주세요", preferredStyle: .alert, completion: nil)
        }
        viewModel.fetchData()
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
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    override func bind() {
        viewModel.$diaryList
            .receive(on: RunLoop.main)
            .sink { diary in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.appendSections([.main])
                snapshot.appendItems(diary, toSection: .main)
                self.datasource.apply(snapshot)
            }.store(in: &subscriptions)
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.diaryCell, for: indexPath) as? DiaryCell else { return nil }
            cell.configuration(item)
            return cell
        })
        
        collectionView.collectionViewLayout = layout()
    }
    
    
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func makeMenuStackView() {
        for i in 0..<viewModel.menuList.count {
            var menuLabel: UILabel = {
                var l = UILabel()
                l.text = viewModel.menuList[i]
                l.textAlignment = .center
                l.font = l.font.withSize(13)
                return l
            }()
            menuStackView.addArrangedSubview(menuLabel)
        }
    }
    
    func makeCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    @objc func clickAddBtn(_ sender: UIButton) {
        viewModel.showAddViewController()
    }
    
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showEditViewController(diary: self.viewModel.diaryList[indexPath.row])
    }
}
