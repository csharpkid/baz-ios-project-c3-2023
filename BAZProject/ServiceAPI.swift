//
//  ServiceAPI.swift
//  BAZProject
//
//  Created by 1029187 on 27/01/23.
//

import Foundation

//TODO: file to add protocols
protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func performDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol ServiceProtocol {
    var session: URLSessionProtocol { get }
    func get<T: Decodable>(_ endpoint: URL, callback: @escaping (Result<T,Error>) -> Void)
}

extension URLSession: URLSessionProtocol {
    func performDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}

class ServiceAPI: ServiceProtocol {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    //TODO: function to consume gets
    func get<T: Decodable>(_ endpoint: URL, callback: @escaping (Result<T,Error>) -> Void) {
        let request: URLRequest = URLRequest(url: endpoint)
        let task = session.performDataTask(with: request) { (data, response, error) in
            if let error: Error = error {
                callback(.failure(error))
                return
            }
            
            guard let data: Data = data else {
                callback(.failure(ServiceError.noData))
                return
            }
            
            guard let response: HTTPURLResponse = response as? HTTPURLResponse else {
                callback(.failure(ServiceError.response))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                callback(.failure(ServiceError.internalServer))
                return
            }
            
            
            do {
                let decodedData: T = try JSONDecoder().decode(T.self, from: data)
                callback(.success(decodedData))
            } catch {
                callback(.failure(ServiceError.parsingData))
            }
        }
        task.resume()
    }
}

enum ServiceError: Error {
    case noData
    case response
    case internalServer
    case parsingData
}

class MovieRequest: NSObject {
    static let baseURL: String = "https://api.themoviedb.org/3/"
    static let apiKey: String = "f6cd5c1a9e6c6b965fdcab0fa6ddd38a"
    
    static func getURL(endpoint: Endpoint) -> URL? {
        let endpoint = endpoint.rawValue
        var requestURL: String
        requestURL = baseURL+endpoint+apiKey
        return URL(string: requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}

//TODO: file to add enum
enum Endpoint: String {
    case trendingMovies = "trending/movie/day?api_key="
}
