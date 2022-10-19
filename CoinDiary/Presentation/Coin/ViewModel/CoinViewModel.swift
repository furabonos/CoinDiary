//
//  CoinViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/13.
//

import Foundation
import Combine
import UIKit
import Alamofire

protocol CoinViewModelInput {
    func loadChart(ticker: String) -> String
    func getTicker()
}

protocol CoinViewModelOutput {
    var ticker: String { get }
    var coins: Array<String> { get }
    var coin: CoinEntity? { get }
    var filterCoins: Array<String> { get }
}

public final class CoinViewModel: CoinViewModelInput, CoinViewModelOutput, ObservableObject {
    
    private let useCase: CoinUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published public var coin: CoinEntity? = nil
    
    @Published public var ticker = ""
    public var coins = Array<String>()
    public var filterCoins = Array<String>()
    
    init(useCase: CoinUseCaseInterface) {
        self.useCase = useCase
    }
    
    func getTicker() {
        useCase.getTicker {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("getticker Error = \(error)")
                }
            } receiveValue: { coin in
                self.coin = coin
            }
            .store(in: &bag)
        }
    }
    
    func loadChart(ticker: String) -> String {
        return """
                               <!-- TradingView Widget BEGIN -->
                               <div class="tradingview-widget-container">
                                 <div id="tradingview_c4588"></div>
                                 <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/symbols/BTCUSDTPERP/?exchange=BINANCE" rel="noopener" target="_blank"><span class="blue-text">BTCUSDTPERP Chart</span></a> by TradingView</div>
                                 <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
                                 <script type="text/javascript">
                                 new TradingView.widget(
                                 {
                                 "autosize": true,
                                 "symbol": "BINANCE:\(ticker)",
                                 "interval": "D",
                                 "timezone": "Asia/Seoul",
                                 "theme": "dark",
                                 "style": "1",
                                 "locale": "en",
                                 "toolbar_bg": "#f1f3f6",
                                 "enable_publishing": false,
                                 "allow_symbol_change": true,
                                 "container_id": "tradingview_c4588"
                               }
                                 );
                                 </script>
                               </div>

"""
    }
    
    
}
