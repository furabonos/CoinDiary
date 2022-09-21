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
//    func makeTabbarController(diary: DiaryViewController, chart: ChartViewController) -> TabbarController
//    func makeDiaryViewController() -> DiaryViewController
    func makeTabbarController(diary: DiaryViewController, chart: ChartViewController, actions: DiaryViewModelAction) -> TabbarController
    func makeDiaryViewController(actions: DiaryViewModelAction) -> DiaryViewController
    func makeChartViewController() -> ChartViewController
    func makeAddViewController() -> AddViewController
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
        let actions = DiaryViewModelAction(showAddViewController: showAddViewController)
        let vc = dependencies.makeTabbarController(diary: makeDiaryViewController(), chart: makeChartViewController(), actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        StartVC = vc
    }
    
    func makeDiaryViewController() -> DiaryViewController {
        let actions = DiaryViewModelAction(showAddViewController: showAddViewController)
        let vc = dependencies.makeDiaryViewController(actions: actions)
        return vc
    }
    
    func makeChartViewController() -> ChartViewController {
        let vc = dependencies.makeChartViewController()
        return vc
    }
    
    private func showAddViewController() {
        let vc = dependencies.makeAddViewController()
        navigationController?.present(vc, animated: true)
    }
    
}
