//
//  ChartViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit
import Combine
import AAInfographics

class ChartViewController: BaseViewController {
    
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
