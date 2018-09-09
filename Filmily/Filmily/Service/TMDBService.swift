//
//  TMDBService.swift
//  Filmily
//
//  Created by Azules on 2018/9/5.
//  Copyright © 2018年 Azules. All rights reserved.
//

import Foundation

class TMDBService {
    
    let key: String = "d184b88235b14fcef7ea6e76fd52cd3e"
    let baseURL: String = "https://api.themoviedb.org/3/"
    
    let defaultSession = URLSession(configuration: .default)
    var discoverDataTask: URLSessionDataTask?
    
    public typealias DiscoverCompletion = (_ DiscoverResult: DiscoverResult?, _ error: Error?) -> Void
    
    open func discoverMovies(page: Int, completion: @escaping DiscoverCompletion) {
        let url = baseURL + "discover/movie"
        let parameters = ["api_key": key, "sort_by": "release_date.desc", "page": String(page), "primary_release_date.lte": "2016-12-31"]
        
        discoverDataTask?.cancel()
        discoverMovies(urlString: url, parameters: parameters, completion: completion)
//        https://api.themoviedb.org/3/discover/movie?api_key=d184b88235b14fcef7ea6e76fd52cd3e&sort_by=release_date.desc&page=1&primary_release_date.lte=2016-12-31
//        https://api.themoviedb.org/3/movie/{movie_id}?api_key=d184b88235b14fcef7ea6e76fd52cd3e
    }
    
    private func discoverMovies(urlString: String, parameters: [String: Any], completion: @escaping (DiscoverCompletion)) {
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        
        for (key, value) in parameters {
            guard let value = value as? String else { return }
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let url = urlComponents.url else { return }
        discoverDataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer { self.discoverDataTask = nil }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let decoder = JSONDecoder()
                
                if let discoverResult = try? decoder.decode(DiscoverResult.self, from: data) {
                    DispatchQueue.main.async {
                        completion(discoverResult, nil)
                    }
                } else {
                    print("decode error")
                }
            }
        })
        
        discoverDataTask?.resume()
    }

}
