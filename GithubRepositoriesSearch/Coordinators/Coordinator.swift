//
//  Coordinator.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit

class Coordinator: CoordinatorPrototype {
    
    var navigationController: UINavigationController?
    
    var rootViewController: UIViewController?
    
    var identifier: UUID
    
    var childCoordinators: [UUID : CoordinatorPrototype]
    
    func start() {
        fatalError("Need to be implemented by successor")
    }
    
    func stop() {
        childCoordinators.values.forEach { $0.stop() }
        childCoordinators.removeAll()
    }
    
    func store(coordinator: CoordinatorPrototype) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func release(coordinator: CoordinatorPrototype) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
    
    func release(identifier: UUID) {
        DispatchQueue.main.async {
            self.childCoordinators.removeValue(forKey: identifier)
        }
    }
    
}

extension Coordinator {
    
    
}
