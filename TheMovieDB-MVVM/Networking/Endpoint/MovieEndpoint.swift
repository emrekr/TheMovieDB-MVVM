//
//  APIEndpoint.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import Foundation

enum MovieEndpoint: Endpoint, Equatable {
    case popular(page: Int)
    case detail(id: Int)
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)
    case videos(id: Int)
    
    var baseURL: String {
        APIConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .popular: return APIPaths.Movie.popular
        case .detail(let id): return APIPaths.Movie.detail(id: id)
        case .nowPlaying: return APIPaths.Movie.nowPlaying
        case .topRated: return APIPaths.Movie.topRated
        case .upcoming: return APIPaths.Movie.upcoming
        case .credits(let id): return APIPaths.Movie.credits(id: id)
        case .similar(let id, _): return APIPaths.Movie.similar(id: id)
        case .videos(let id): return APIPaths.Movie.videos(id: id)
        }
    }
    
    private var languageParam: URLQueryItem {
        URLQueryItem(name: "language", value: APIConfig.languageCode)
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page),
             .nowPlaying(let page),
             .topRated(let page),
             .upcoming(let page),
             .similar(_, let page):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "language", value: APIConfig.languageCode)
            ]
        case .detail, .credits, .videos:
            return [
                URLQueryItem(name: "language", value: APIConfig.languageCode)
            ]
        }
    }
    
    var method: HTTPMethod { .get }
}
