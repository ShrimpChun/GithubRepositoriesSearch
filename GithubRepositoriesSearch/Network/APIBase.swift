//
//  APIBase.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation
import Combine

struct APIBase {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func lazyFetching<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }

}

enum APIPath: String {
    case searchRepository = "search/repositories"
}
