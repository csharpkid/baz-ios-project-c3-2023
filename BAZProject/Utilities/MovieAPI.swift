//
//  MovieAPI.swift
//  BAZProject
//
//

import UIKit

public enum URLApi: Hashable {
    
    case upcoming
    case trending
    case nowPlaying
    case popular
    case topRated
    case keyword
    case searchMovie
    case reviews
    case similar
    case recommendations
    case creditMovie
    
    var getEndpointUrl: String {
        switch self {
        case .upcoming:
            return "/movie/upcoming"
        case .trending:
            return "/trending/movie/day"
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        case .keyword:
            return "/search/keyword"
        case .searchMovie:
            return "/search/movie"
        case .reviews:
            return "/reviews"
        case .similar:
            return "/similar"
        case .recommendations:
            return "/recommendations"
        case .creditMovie:
            return "/credits"
        }
    }
}

final class MovieAPI {
    static private let imgBaseUrl: String = "https://image.tmdb.org/t/p/w500"
    static private var apiKey: String = "f6cd5c1a9e6c6b965fdcab0fa6ddd38a"
    static private var urlBase: String = "https://api.themoviedb.org/3"
    
    /**    func to help to get Data of apis
     - Parameter url: url of api
     
     */
    static func getApiData(from url:URLApi, handler: @escaping (Data) -> Void) {
        guard let url = URL(string: "\(urlBase)\(url.getEndpointUrl)?api_key=\(apiKey)&language=es&region=MX&page=1") else { return }
        let task =  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let datos = data else { return }
            handler(datos)
        }
        task.resume()
    }
    
    /**    func to help to get Data of apis with key
     - Parameter url: endpoint of URLApi
     - Parameter key: Word to search
     */
    static func getApiData(from url: URLApi, key query: String, handler: @escaping (Data) -> Void) {
        guard let url = URL(string: "\(urlBase)\(url.getEndpointUrl)?api_key=\(apiKey)&language=es&page=1&query=\(query)") else { return }
        let task =  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let datos = data else { return }
            handler(datos)
        }
        task.resume()
    }
    
    /**    func to help to get Data of apis with idMovies
     - Parameter url: endpoint of URLApi
     - Parameter id: id of movie
     */
    static func getApiData(from url: URLApi, id idMovie: Int, handler: @escaping (Data) -> Void) {
        guard let url = URL(string: "\(urlBase)/movie/\(idMovie)\(url.getEndpointUrl)?api_key=\(apiKey)&language=es")
        else { return }
        let task =  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let datos = data else { return }
            handler(datos)
        }
        task.resume()
    }
    
    /**    func to help to get a image
     
    - Parameter imageUrl: url of image
     
    */
    static func getImage(from imageUrl: String, handler: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: "\(imgBaseUrl)\(imageUrl)") else { return }
            let data = try? Data(contentsOf: url)
            guard let data = data else { return }
            self.getDataImage(data: data) { image in
                handler(image)
            }
        }
    }
    
    static private func getDataImage(data: Data, handler: @escaping (UIImage) -> Void) {
        DispatchQueue.main.async {
            guard let image = UIImage(data: data) else { return }
            handler(image)
        }
    }
}