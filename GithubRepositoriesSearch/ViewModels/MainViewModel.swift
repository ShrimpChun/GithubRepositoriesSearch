//
//  MainViewModel.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import Combine

protocol MainViewModelInput {
    func reload(by name: String?)
    func loadMore()
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
    
    @Published private var repositoryModels = [RepositoryElementModel]()
    
    private var cancelable = Set<AnyCancellable>()
    
    // MARK: - Private property
    private var isLoading = true
    private var incomplete_results = true
    private var searchrespositoryName = ""
    private var page = 1
    
}

// MARK: - Input & Output
extension MainViewModel: MainViewModelInput {
    
    func reload(by name: String?) {
        
        self.incomplete_results = true
        self.page = 1

        guard let name = name, name.count > 0 else {
            self.repositoryModels.removeAll()
            self.searchrespositoryName = ""
            return
        }
        
        self.searchrespositoryName = name
        self.searchRepository(by: self.searchrespositoryName, page: 1)
        
    }
    
    private func searchRepository(by name: String, page: Int) {
        
        GithubDB.request(.searchRepository, name: name, page: page)
            .mapError { error -> Error in
                self.isLoading = false
                print(error)
                return error
            }
            .sink { _ in
                
            } receiveValue: {
                guard $0.items != nil else { return }
                self.page == 1 ? self.repositoryModels = $0.items! : self.repositoryModels.append(contentsOf: $0.items!)
                self.incomplete_results = $0.incomplete_results ?? true
                self.isLoading = false
                self.page += 1
            }
            .store(in: &cancelable)

    }
    
    func loadMore() {
        
        guard !isLoading && !incomplete_results else {
            return
        }
        
        isLoading = true
        self.searchRepository(by: self.searchrespositoryName, page: self.page)
        
    }
    
    func showRepositorInfo(by index: Int) {
        
        // We can do something...
        print(self.repositoryModels[index])
        
    }
    
}

extension MainViewModel: MainViewModelOutput {
    
    var models: AnyPublisher<[RepositoryElementModel], Never> {
        $repositoryModels.eraseToAnyPublisher()
    }
    
}
