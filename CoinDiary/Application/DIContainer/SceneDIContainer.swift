//
//  SceneDIContainer.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import UIKit

final class SceneDIContainer: FlowCoordinatorDependencies {
    
    // MARK: - Repositories
    func makeDiaryRepository() -> DiaryRepository {
        let dataSource: DiaryDataSourceInterface
        dataSource = DiaryDataSource() 
        return DiaryRepository(dataSource: dataSource)
    }
    
    func makeChartRepository() -> ChartRepository {
        let dataSource: ChartDataSourceInterface
        dataSource = ChartDataSource()
        return ChartRepository(dataSource: dataSource)
    }
    
    // MARK: - UseCase
    func makeDiaryUseCase() -> DiaryUseCase {
        return DiaryUseCase(repository: makeDiaryRepository())
    }
    
    func makeChartUseCase() -> ChartUseCase {
        return ChartUseCase(repository: makeChartRepository())
    }
    // MARK: - Presentation
    func makeTabbarController(diary: DiaryViewController, chart: ChartViewController) -> TabbarController {
        return TabbarController(diary: makeDiaryViewController(), chart: makeChartViewController())
    }
    
    func makeDiaryViewModel() -> DiaryViewModel {
        return DiaryViewModel(useCase: makeDiaryUseCase())
    }
    
    func makeChartViewModel() -> ChartViewModel {
        return ChartViewModel(useCase: makeChartUseCase())
    }
    
    func makeDiaryViewController() -> DiaryViewController {
        return DiaryViewController.create(with: makeDiaryViewModel())
    }
    
    func makeChartViewController() -> ChartViewController {
        return ChartViewController.create(with: makeChartViewModel())
    }
    
    // MARK: - Flow Coordinators
    func makeFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    
}
