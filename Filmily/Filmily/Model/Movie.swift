//
//  Movie.swift
//  Filmily
//
//  Created by Azules on 2018/9/2.
//  Copyright © 2018年 Azules. All rights reserved.
//

import Foundation

struct DiscoverResult: Codable {
    var page: Int?
    var total_pages: Int?
    var total_results: Int?
    var results: [Movie]?
}

struct Movie: Codable {
    var id: Int?
    var title: String?
    var poster_path: String?
    var backdrop_path: String?
    var popularity: Double?
    var overview: String?
    var original_language: String?
    var runtime: Int?
    var genres: [Genres]?
    
    struct Genres: Codable {
        var id: Int?
        var name: String?
    }
}
