//
//  AppDIContainer.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/15.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - DIContainers of scenes
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer()
        return dependencies
    }
    
}
