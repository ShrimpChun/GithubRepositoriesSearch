//
//  GithubDB.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import Combine

enum GithubDB {
    static let apiBase = APIBase()
    static let baseURL: URL = URL(string: "https://api.github.com")!
}

extension GithubDB {
    
    static func request(_ path: APIPath, name: String, page: Int = 1) -> AnyPublisher<RepositoryListModel, Error> {
        
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents.")
        }
        
        components.queryItems = [URLQueryItem(name: "q", value: name), URLQueryItem(name: "page", value: String(format: "%d", page))]
        
        let request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        
        return apiBase.lazyFetching(request)
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
}
