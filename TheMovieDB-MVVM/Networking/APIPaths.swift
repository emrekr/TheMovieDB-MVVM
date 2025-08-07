//
//  APIPaths.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

enum APIPaths {
    enum Movie {
        static let popular = "/movie/popular"
        static let nowPlaying = "/movie/now_playing"
        static let topRated = "/movie/top_rated"
        static let upcoming = "/movie/upcoming"
        
        static func detail(id: Int) -> String { "/movie/\(id)" }
        static func credits(id: Int) -> String { "/movie/\(id)/credits" }
        static func similar(id: Int) -> String { "/movie/\(id)/similar" }
        static func videos(id: Int) -> String { "/movie/\(id)/videos" }
    }
    
    enum Search {
        static let movie = "/search/movie"
    }
}
