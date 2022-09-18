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
    
    init(diary: DiaryViewController, chart: ChartViewController) {
        self.diary = diary
        self.chart = chart
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = self.diary
        let second = self.chart
        
        let tabList = [first, second]
        
        tabList[0].title = "매매일지"
        tabList[1].title = "자산그래프"
        
        viewControllers = tabList
        self.tabBar.backgroundColor = Colors.iosGrey
        self.tabBar.items![0].image = UIImage(systemName: "dollarsign.circle")
        self.tabBar.items![1].image = UIImage(systemName: "chart.line.uptrend.xyaxis")
    }

}
