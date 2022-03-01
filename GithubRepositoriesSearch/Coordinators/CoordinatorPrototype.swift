//
//  CoordinatorPrototype.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import UIKit

protocol CoordinatorPrototype: AnyObject {
    
    // MARK: - Property
    var navigationController: UINavigationController? { get set }
    var rootViewController: UIViewController? { get }
    var identifier: UUID { get }
    var childCoordinators: [UUID: CoordinatorPrototype] { get set }
    
    // MARK: - Function
    func start()
    func stop()
    func store(coordinator: CoordinatorPrototype)
    func release(coordinator: CoordinatorPrototype)
    
}
