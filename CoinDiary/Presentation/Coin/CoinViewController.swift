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
    
    var dropBtn: UIButton = {
        var b = UIButton()
        b.setTitle("티커를 선택해주세요.", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(clickSelect(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var webView: WKWebView = {
        var wv = WKWebView()
        return wv
    }()
    
    let dropDown = DropDown()
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
        setupDropdown()
        //
        let urls = "https://fapi.binance.com/fapi/v1/exchangeInfo"

        var aa = AF.request(urls, method: .get, encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: CoinDTO.self)
            .value()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error = \(error)")
                }
            } receiveValue: { diaryList in
                print("씨발 = \(diaryList)")
            }
//            .eraseToAnyPublisher()
        
//        aa.sink { completion in
//            switch completion {
//            case .finished:
//                break
//            case .failure(let error):
//                print("error = \(error)")
//            }
//        } receiveValue: { diaryList in
//            print("씨발 = \(diaryList)")
//        }
//        .store(in: &bag)
//        print("aaaaa = \(aa)")
        //
    }
    
    override func setupUI() {
        [dropBtn, webView].forEach { self.view.addSubview($0) }
    }
    
    override func setupConstraints() {
        dropBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-20)
            $0.width.equalTo(150)
            $0.height.equalTo(40)
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(dropBtn.snp.bottom).offset(20)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    override func bind() {
        viewModel.$ticker
            .receive(on: RunLoop.main)
            .sink { ticker in
                if ticker != "" {
                    self.webView.loadHTMLString(self.viewModel.loadChart(ticker: ticker), baseURL: nil)
                }
            }.store(in: &subscriptions)
    }
    
    func setupDropdown() {
        DropDown.appearance().textColor = .black
        DropDown.appearance().selectedTextColor = .red
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = .lightGray
        dropDown.dismissMode = .automatic
        dropDown.dataSource = self.viewModel.coins
        dropDown.anchorView = dropBtn
        dropDown.bottomOffset = CGPoint(x: 0, y: 40)
        dropDown.cornerRadius = 10
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.viewModel.ticker != item {
                self.viewModel.ticker = item
                self.dropBtn.setTitle(item, for: .normal)
            }
            self.dropDown.clearSelection()
        }
    }
    
    @objc func clickSelect(_ sender: UIButton) {
        dropDown.show()
    }

}
