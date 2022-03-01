//
//  AppCoordinator.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator<Void> {
    
    // MARK: - Life cycle
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let next = MainViewController()
    }
    
}
