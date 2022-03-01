//
//  MainCoordinator.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit

class MainCoordinator: Coordinator<Void> {
    
    // MARK: - Private
    private let window: UIWindow
    
    // MARK: - Life cycle
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let vc = MainViewController()
        navigationController = UINavigationController(rootViewController: vc)
        
        rootViewController = vc
        
        window.rootViewController = navigationController
    }
    
}
