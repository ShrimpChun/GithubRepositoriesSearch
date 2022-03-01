//
//  AppCoordinator.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Private property
    private let window: UIWindow
    
    // MARK: - Life cycle
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let next = MainCoordinator(window: window)
        next.start()
        store(coordinator: next)
    }
    
}
