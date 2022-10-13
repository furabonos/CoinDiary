//
//  ChartViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit
import Combine
import AAInfographics
import SnapKit
import WebKit

class ChartViewController: BaseViewController {
    
//    lazy var webView: WKWebView = {
//        var wv = WKWebView()
//        return wv
//    }()
    
    lazy var chartView: AAChartView = {
        var cv = AAChartView()
        return cv
    }()
    
    var aaChartModel = AAChartModel()
    
    public var viewModel: ChartViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: ChartViewModel) -> ChartViewController {
        let view = ChartViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
//        self.view.addSubview(webView)
//        webView.snp.makeConstraints {
//            $0.top.leading.bottom.trailing.equalToSuperview()
//        }
//        webView.loadHTMLString("""
//                               <!-- TradingView Widget BEGIN -->
//                               <div class="tradingview-widget-container">
//                                 <div id="tradingview_c4588"></div>
//                                 <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/symbols/BTCUSDTPERP/?exchange=BINANCE" rel="noopener" target="_blank"><span class="blue-text">BTCUSDTPERP Chart</span></a> by TradingView</div>
//                                 <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
//                                 <script type="text/javascript">
//                                 new TradingView.widget(
//                                 {
//                                 "autosize": true,
//                                 "symbol": "BINANCE:XRPUSDTPERP",
//                                 "interval": "D",
//                                 "timezone": "Asia/Seoul",
//                                 "theme": "dark",
//                                 "style": "1",
//                                 "locale": "en",
//                                 "toolbar_bg": "#f1f3f6",
//                                 "enable_publishing": false,
//                                 "allow_symbol_change": true,
//                                 "container_id": "tradingview_c4588"
//                               }
//                                 );
//                                 </script>
//                               </div>
//
//""", baseURL: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeChartView()
    }
    
    override func bind() {
        viewModel.$endList
            .receive(on: RunLoop.main)
            .sink { data in
                self.makeChartView()
                self.aaChartModel.chartType(.line)//Can be any of the chart types listed under `AAChartType`.
                    .animationType(.bounce)
                    .title("계좌그래프")//The chart title
                    .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
                    .tooltipValueSuffix(self.getStringUserDefaults(key: "unit"))//the value suffix of the chart tooltip
                    .categories(self.viewModel.dateList)
                    .colorsTheme(["#fe117c"])
                    .series([
                        AASeriesElement()
                            .name("내 계좌")
                            .data(data),
                            ])
                self.chartView.aa_drawChartWithChartModel(self.aaChartModel)
            }.store(in: &subscriptions)
    }
    
    func makeChartView() {
        self.view.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func removeChartView() {
        chartView.removeFromSuperview()
        viewModel.endList.removeAll()
        viewModel.dateList.removeAll()
    }

}
