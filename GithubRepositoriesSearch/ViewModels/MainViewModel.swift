//
//  MainViewModel.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import Combine

protocol MainViewModelInput {
    func searchRepository(by name: String?)
    func loadMore(by page: Int)
    func showRepositorInfo(by index: Int)
}

protocol MainViewModelOutput {
    var models: AnyPublisher<[RepositoryElementModel], Never> { get }
}

protocol MainViewModelPrototype {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

// MARK: - View model
class MainViewModel: MainViewModelPrototype {
    
    let reaction = PassthroughSubject<RepositoryListModel, Never>()
    
    var input: MainViewModelInput { self }
    var output: MainViewModelOutput { self }
    
    private var cancelable = Set<AnyCancellable>()
    private var isLoading = true

    @Published private var repositoryModels = [RepositoryElementModel]()
    @Published private var page = 1
}

// MARK: - Input & Output
extension MainViewModel: MainViewModelInput {
    
    func searchRepository(by name: String?) {

        guard let name = name, name.count > 0 else {
            self.repositoryModels.removeAll()
            return
        }
        
        GithubDB.request(.searchRepository, name: name)
            .mapError { error -> Error in
                print(error)
                return error
            }
            .sink { _ in
                
            } receiveValue: {
                print($0.incomplete_results)
                print($0.total_count)
                self.repositoryModels = $0.items
            }
            .store(in: &cancelable)

    }
    
    func loadMore(by page: Int) {
        
        guard !isLoading else {
            return
        }
        
    }
    
    func showRepositorInfo(by index: Int) {
        
    }
    
}

extension MainViewModel: MainViewModelOutput {
    
    var models: AnyPublisher<[RepositoryElementModel], Never> {
        $repositoryModels.eraseToAnyPublisher()
    }
    
}
