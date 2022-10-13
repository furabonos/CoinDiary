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
    
    func makeAddRepository() -> AddRepository {
        let dataSource: AddDataSourceInterface
        dataSource = AddDataSource()
        return AddRepository(dataSource: dataSource)
    }
    
    func makeEditRepository() -> EditRepository {
        let dataSource: EditDataSourceInterface
        dataSource = EditDataSource()
        return EditRepository(dataSource: dataSource)
    }
    
    // MARK: - UseCase
    func makeDiaryUseCase() -> DiaryUseCase {
        return DiaryUseCase(repository: makeDiaryRepository())
    }
    
    func makeChartUseCase() -> ChartUseCase {
        return ChartUseCase(repository: makeChartRepository())
    }
    
    func makeAddUseCase() -> AddUseCase {
        return AddUseCase(repository: makeAddRepository())
    }
    
    func makeEditUseCase() -> EditUseCase {
        return EditUseCase(repository: makeEditRepository())
    }
    
    // MARK: - Presentation
    func makeTabbarController(diary: DiaryViewController, chart: ChartViewController, coin: CoinViewController, actions: DiaryViewModelAction) -> TabbarController {
        return TabbarController(diary: makeDiaryViewController(actions: actions), chart: makeChartViewController(), coin: makeCoinViewController())
    }
    
    func makeDiaryViewModel(actions: DiaryViewModelAction) -> DiaryViewModel {
        return DiaryViewModel(useCase: makeDiaryUseCase(), actions: actions)
    }
    
    func makeChartViewModel() -> ChartViewModel {
        return ChartViewModel(useCase: makeChartUseCase())
    }
    
    func makeAddViewModel() -> AddViewModel {
        return AddViewModel(useCase: makeAddUseCase())
    }
    
    func makeEditViewModel(diary: DiaryEntity) -> EditViewModel {
        return EditViewModel(useCase: makeEditUseCase(), diary: diary)
    }
    
    func makeCoinViewModel() -> CoinViewModel {
        return CoinViewModel()
    }
    
    func makeDiaryViewController(actions: DiaryViewModelAction) -> DiaryViewController {
        return DiaryViewController.create(with: DiaryViewModel(useCase: makeDiaryUseCase(), actions: actions))
    }
    
    func makeChartViewController() -> ChartViewController {
        return ChartViewController.create(with: makeChartViewModel())
    }
    
    func makeAddViewController() -> AddViewController {
        return AddViewController.create(with: makeAddViewModel())
    }
    
    func makeEditViewController(diary: DiaryEntity) -> UIViewController {
        return EditViewController.create(with: makeEditViewModel(diary: diary))
    }
    
    func makeCoinViewController() -> CoinViewController {
        return CoinViewController.create(with: makeCoinViewModel())
    }
    
    // MARK: - Flow Coordinators
    func makeFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    
}
