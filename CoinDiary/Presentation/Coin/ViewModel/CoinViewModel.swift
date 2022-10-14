//
//  CoinViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/13.
//

import Foundation
import Combine
import UIKit

protocol CoinViewModelInput {
    var ticker: String { get }
    var coins: Array<String> { get }
}

protocol CoinViewModelOutput {
    func loadChart(ticker: String) -> String
}

public final class CoinViewModel: CoinViewModelInput, CoinViewModelOutput, ObservableObject {
    
    @Published public var ticker = ""
    public var coins = ["XRPUSDTPERP", "BTCUSDTPERP", "BCHUSDTPERP"]
    
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
    
//    var viewModePublisher = PassthroughSubject<ViewMode, Never>()
//    public var viewMode = ViewMode.None {
//        didSet {
//            viewModePublisher.send(viewMode)
//        }
//    }
//
//    var saveDataPublisher = PassthroughSubject<Bool, Never>()
//    public var saveData = false {
//        didSet {
//            saveDataPublisher.send(saveData)
//        }
//    }
//
//    private let useCase: EditUseCaseInterface
//    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
//    @Published var diary: DiaryEntity
    
    
}
