//
//  TabbarController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import UIKit

class TabbarController: UITabBarController {
    
//    var appFlowCoordinator: AppFlowCoordinator?
    var diary: DiaryViewController
    var chart: ChartViewController
    var coin: CoinViewController
    var calculator: CalculatorViewController
    
    init(diary: DiaryViewController, chart: ChartViewController, coin: CoinViewController, calculator: CalculatorViewController) {
        self.diary = diary
        self.chart = chart
        self.coin = coin
        self.calculator = calculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = self.diary
        let second = self.chart
//        let third = self.coin
        let fourth = self.calculator
        
        let tabList = [first, second, fourth]
        
        tabList[0].title = "매매일지"
        tabList[1].title = "자산그래프"
//        tabList[2].title = "차트"
        tabList[2].title = "계산기"
        
        viewControllers = tabList
        self.tabBar.backgroundColor = Colors.iosGrey
        
        self.tabBar.items![0].image = UIImage(systemName: "square.and.pencil")
        self.tabBar.items![1].image = UIImage(systemName: "chart.xyaxis.line")
//        self.tabBar.items![2].image = UIImage(systemName: "chart.bar.xaxis")
        self.tabBar.items![2].image = UIImage(systemName: "wonsign.circle")
    }

}
