//
//  APIBase.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import Foundation

struct Resource<T> {
    let request: NSMutableURLRequest
    let parse: (URLResponse?, Data) -> T?
}

class APIService: NSObject, URLSessionDelegate {
    
    static let sharedInstance = APIService()
    
    private let BaseURL: String = "https://api.github.com"
    
    func searchRepositories(name: String, completion: @escaping(Result<RepositoryModel?, Error>) -> ()) {
        let parameters = ["q": name]
        
        let request = initGetRequest(requestURL: String(describing: "search/repositories"), parameters: parameters)
        let resource = Resource<RepositoryModel>(request: request) { (response, data) in
            let resource = try? JSONDecoder().decode(RepositoryModel.self, from: data)
            return resource
        }
        
        lazyFetching(resource: resource,
                     request: request,
                     completionBlock: completion)
    }
    
}

extension APIService {
    
    private func initGetRequest(requestURL: String, parameters: [String: String]) -> NSMutableURLRequest {
        
        let queryString = NSMutableString()
        parameters.forEach {
            queryString.append(String(format: "%@=%@&", $0.key, $0.value))
        }
        
        let urlString = String(format: "%@/%@?%@", BaseURL, requestURL, queryString)
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let request = NSMutableURLRequest(url: URL(string: encodedString)!,
                                          cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                          timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        return request
        
    }
    
}

extension APIService {
    
    func lazyFetching<T: Decodable>(resource: Resource<T>, request: NSMutableURLRequest, completionBlock: @escaping(Result<T?, Error>) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionBlock(.failure(error))
                }
                if let data = data {
                    completionBlock( Result { resource.parse(response, data) } )
                }
            }
        }
        task.resume()
    }
    
}
