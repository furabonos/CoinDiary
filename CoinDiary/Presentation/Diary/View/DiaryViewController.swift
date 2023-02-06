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
import Photos
import CryptoKit

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
    
    lazy var menuBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "line.3.horizontal")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 30
        b.addAllShadow()
        b.addTarget(self, action: #selector(clickMenuBtn(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var removeBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "trash.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 30
        b.addAllShadow()
        b.addTarget(self, action: #selector(clickRemoveBtn(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var addBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        b.backgroundColor = .systemBackground
        b.layer.cornerRadius = 30
        b.addAllShadow()
        b.addTarget(self, action: #selector(clickAddBtn(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        var iv = UIActivityIndicatorView()
        return iv
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
        
        PHPhotoLibrary.requestAuthorization { (state) in
                print(state)
            }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.viewModel.menuBools = false
        
        self.removeBtn.snp.remakeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        self.addBtn.snp.remakeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        [self.removeBtn, self.addBtn].forEach { $0.isHidden = true }
        
        
    }
    
    override func setupUI() {
        [menuStackView, collectionView, menuBtn, removeBtn, addBtn, indicatorView].forEach { self.view.addSubview($0) }
        [removeBtn, addBtn].forEach { $0.isHidden = true }
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
        
        menuBtn.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        removeBtn.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addBtn.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
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
        
        viewModel.menuBoolsPublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value {
                    self.menuInOut(bools: value)
                }else {
                    self.menuInOut(bools: value)
                }
            }.store(in: &subscriptions)
        
        viewModel.removeBoolPublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                self.indicatorView.stopAnimating()
                if !value {
                    showAlert(message: "삭제에 실패했습니다. 잠시후에 다시 시도해주세요.")
                }
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
    
    @objc func clickMenuBtn(_ sender: UIButton) {
        self.viewModel.toggleMenuBools()
    }
    
    @objc func clickAddBtn(_ sender: UIButton) {
        self.viewModel.showAddViewController()
    }
    
    @objc func clickRemoveBtn(_ sender: UIButton) {
        
        if self.viewModel.diaryList.count == 0 {
            showAlert(message: "삭제할 기록이 없습니다.")
        }else {
            let alert = UIAlertController(title: "", message: "기록을 초기화 하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
                self.indicatorView.startAnimating()
                self.viewModel.removeAllData()
            })
            let cancelAction = UIAlertAction(title: "취소", style: .default)
            [okAction, cancelAction].forEach { alert.addAction($0) }

            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func menuInOut(bools: Bool) {
        if bools {
            
            [self.removeBtn, self.addBtn].forEach { $0.isHidden = false }

            self.removeBtn.snp.remakeConstraints {
                $0.width.height.equalTo(60)
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalTo(self.menuBtn.snp.top).offset(-20)
            }

            self.addBtn.snp.remakeConstraints {
                $0.width.height.equalTo(60)
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalTo(self.removeBtn.snp.top).offset(-20)
            }

            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }else {

            self.removeBtn.snp.remakeConstraints {
                $0.width.height.equalTo(60)
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }

            self.addBtn.snp.remakeConstraints {
                $0.width.height.equalTo(60)
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            } completion: { value in
                [self.removeBtn, self.addBtn].forEach { $0.isHidden = true }
            }

        }
    }
    
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showEditViewController(diary: self.viewModel.diaryList[indexPath.row])
    }
}
