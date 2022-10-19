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
import WebKit
import Alamofire

class CoinViewController: BaseViewController {
    
    lazy var webView: WKWebView = {
        var wv = WKWebView()
        wv.backgroundColor = .systemBackground
        return wv
    }()
    
    lazy var searchBar: UISearchBar = {
        var sb = UISearchBar()
        sb.delegate = self
        return sb
    }()
    
    var coinCell = "CoinCell"
    enum Section {
        case main
    }
    typealias Item = String
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(CoinCell.self, forCellWithReuseIdentifier: self.coinCell)
        cv.delegate = self
        return cv
    }()
    
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
        searchBar.setValue("취소", forKey: "cancelButtonText")
        configureCollectionView()
        self.viewModel.getTicker()
    }
    
    override func setupUI() {
        [searchBar, collectionView, webView].forEach { self.view.addSubview($0) }
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        self.webView.snp.makeConstraints {
            $0.top.equalTo(self.searchBar.snp.bottom).offset(20)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        self.webView.isHidden = true
    }
    
    override func bind() {
        viewModel.$ticker
            .receive(on: RunLoop.main)
            .sink { ticker in
                self.webView.loadHTMLString(self.viewModel.loadChart(ticker: ticker), baseURL: nil)
            }.store(in: &subscriptions)

        viewModel.$coin
            .receive(on: RunLoop.main)
            .sink { coin in
                guard let coinz = coin else { return }
                for i in 0..<coinz.symbols.count {
                    if coinz.symbols[i].contractType == "PERPETUAL" {
                        self.viewModel.coins.append("\(coinz.symbols[i].symbol)PERP")
                    }
                }
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self.viewModel.coins, toSection: .main)
                self.datasource.apply(snapshot)
            }.store(in: &subscriptions)
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.coinCell, for: indexPath) as? CoinCell else { return nil }
            cell.configuration(coin: item)
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
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchText == "" {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.viewModel.coins, toSection: .main)
            self.datasource.apply(snapshot)
        }else {
            self.viewModel.filterCoins = self.viewModel.coins.filter { (coin: String) -> Bool in
                return coin.lowercased().contains(searchText.lowercased())
            }
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.viewModel.filterCoins, toSection: .main)
            self.datasource.apply(snapshot)
        }
        
    }

}

extension CoinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //입력시작
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.filterContentForSearchText(searchText)
        self.webView.isHidden = true
        self.collectionView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.text = nil
        self.view.endEditing(true)
        self.filterContentForSearchText("")
        self.webView.isHidden = true
        self.collectionView.isHidden = false
    }
}

extension CoinViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.isHidden = true
        self.webView.isHidden = false
        
        if self.searchBar.searchTextField.text == "" {
            self.viewModel.ticker = self.viewModel.coins[indexPath.row]
            self.searchBar.searchTextField.text = self.viewModel.coins[indexPath.row]
        }else {
            self.viewModel.ticker = self.viewModel.filterCoins[indexPath.row]
            self.searchBar.searchTextField.text = self.viewModel.filterCoins[indexPath.row]
        }
    }
}
