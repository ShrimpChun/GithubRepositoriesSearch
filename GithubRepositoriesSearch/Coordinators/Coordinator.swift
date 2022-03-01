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
    
    var identifier: UUID = UUID()
    
    var childCoordinators: [UUID : CoordinatorPrototype] = [:]
    
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

// MARK: - Presenter
extension Coordinator {
    
    func presentCoordinator(coordinator: CoordinatorPrototype, style: UIModalPresentationStyle = .automatic, animated: Bool = true, completion: (() -> ())? = nil) {
        
        coordinator.start()
        
        guard let controller = coordinator.navigationController ?? coordinator.rootViewController else { return }
        
        controller.modalPresentationStyle = style
        
        rootViewController?.present(controller, animated: animated, completion: completion)
        store(coordinator: coordinator)
        
    }
    
    func dismiss(coordinator: CoordinatorPrototype, completion: (() -> ())? = nil) {
        
        rootViewController?.dismiss(animated: true, completion: completion)
        release(coordinator: coordinator)
        coordinator.stop()
        
    }
    
    func push(childCoordinator: CoordinatorPrototype, animated: Bool) {
        
        guard let nav = navigationController else { return }
        
        childCoordinator.navigationController = nav
        childCoordinator.start()
        
        guard let controller = childCoordinator.rootViewController else { return }
        
        nav.pushViewController(controller, animated: animated)
        store(coordinator: childCoordinator)
        
    }
    
    func pop(childCoordinator: CoordinatorPrototype, animated: Bool) {
        
        guard let nav = navigationController, childCoordinators[childCoordinator.identifier] != nil else { return }
        
        nav.popViewController(animated: animated)
        
        release(coordinator: childCoordinator)
        childCoordinator.stop()
        
    }
    
    func popToRoot(animated: Bool) {
        
        guard let nav = navigationController else { return }
        
        nav.popToRootViewController(animated: animated)
        childCoordinators.forEach {
            $0.value.stop()
        }
        childCoordinators.removeAll()
        
    }
}
