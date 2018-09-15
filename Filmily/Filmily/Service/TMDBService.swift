//
//  TMDBService.swift
//  Filmily
//
//  Created by Azules on 2018/9/5.
//  Copyright © 2018年 Azules. All rights reserved.
//

import Foundation
import Alamofire

class TMDBService {
    
    static let shared = TMDBService()
    
    let key: String = "d184b88235b14fcef7ea6e76fd52cd3e"
    let baseURL: String = "https://api.themoviedb.org/3/"
    
    public typealias DiscoverCompletion = (_ discoverResult: DiscoverResult?, _ error: Error?) -> Void
    public typealias GetMovieCompletion = (_ getMovieResult: Movie?, _ error: Error?) -> Void
    
    open func discoverMovies(page: Int, completion: @escaping DiscoverCompletion) {
        let url = baseURL + "discover/movie"
        let parameters = ["api_key": key, "sort_by": "release_date.desc", "page": String(page), "primary_release_date.lte": "2016-12-31"]
        
        discoverMovies(urlString: url, parameters: parameters, completion: completion)
    }
    
    open func getMovieDetail(id: Int, completion: @escaping GetMovieCompletion) {
        let url = baseURL + "movie/" + String(describing: id)
        let parameters = ["api_key": key]
        
        getMovieDetail(urlString: url, parameters: parameters, completion: completion)
    }
    
    private func discoverMovies(urlString: String, parameters: [String: Any], completion: @escaping DiscoverCompletion) {
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    do {
                        let decoder = JSONDecoder()
                        let discoverResult = try decoder.decode(DiscoverResult.self, from: response.data!)
                        DispatchQueue.main.async {
                            completion(discoverResult, nil)
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, response.error)
                    }
                }
        }
    }
    
    private func getMovieDetail(urlString: String, parameters: [String: Any], completion: @escaping GetMovieCompletion) {
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    do {
                        let decoder = JSONDecoder()
                        let getMovieResult = try decoder.decode(Movie.self, from: response.data!)
                        DispatchQueue.main.async {
                            completion(getMovieResult, nil)
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, response.error)
                    }
                }
        }
    }

}
