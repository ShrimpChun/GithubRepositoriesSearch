//
//  UITableViewCell+Extension.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit

extension UITableView {
    
    // MARK: - Regist Cell
    func register(_ cellClass: AnyClass...) {
        cellClass.forEach {
            self.register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
}

extension UITableViewCell {
    
    static func use(tableView: UITableView, for index: IndexPath) -> Self {
        return cell(tableView: tableView, for: index)
    }
    
    private static func cell<T>(tableView: UITableView, for index: IndexPath) -> T {
        
        let id = String(describing: self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: index) as? T else {
            assert(false)
        }
        
        return cell
        
    }
    
}
