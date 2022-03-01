//
//  MainViewModel.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation

protocol MainViewModelInput {
    func reload()
    func loadMore()
    func showRepositorInfo(by index: Int)
}

protocol MainViewModelOutput {
    
}

protocol MainViewModelPrototype {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

// MARK: - View model
class MainViewModel: MainViewModelPrototype {
    
    

    var input: MainViewModelInput { self }
    var output: MainViewModelOutput { self }
    
}

extension MainViewModel: MainViewModelInput {
    
    func reload() {
        
    }
    
    func loadMore() {
        
    }
    
    func showRepositorInfo(by index: Int) {
        
    }
    
}

extension MainViewModel: MainViewModelOutput { }
