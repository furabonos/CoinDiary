//
//  FlowCoordinator.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import UIKit

protocol FlowCoordinatorDependencies  {
//    func makeUserViewController(actions: UsersViewModelActions) -> UserViewController
//    func makeNextViewController() -> UIViewController
    func makeTabbarController(diary: DiaryViewController, chart: ChartViewController) -> TabbarController
    func makeDiaryViewController() -> DiaryViewController
    func makeChartViewController() -> ChartViewController
}

final class FlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: FlowCoordinatorDependencies
    
    private weak var StartVC: TabbarController?
    
    init(navigationController: UINavigationController, dependencies: FlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeTabbarController(diary: makeDiaryViewController(), chart: makeChartViewController())
        navigationController?.pushViewController(vc, animated: false)
        StartVC = vc
    }
    
    func makeDiaryViewController() -> DiaryViewController {
        let vc = dependencies.makeDiaryViewController()
        return vc
    }
    
    func makeChartViewController() -> ChartViewController {
        let vc = dependencies.makeChartViewController()
        return vc
    }
    
}
