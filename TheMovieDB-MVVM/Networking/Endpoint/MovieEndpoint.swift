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
    
    var baseURL: String {
        APIConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .popular:
            return APIPaths.Movie.popular
        case .detail(let id):
            return APIPaths.Movie.detail(id: id)
        case .nowPlaying:
            return APIPaths.Movie.nowPlaying
        case .topRated:
            return APIPaths.Movie.topRated
        case .upcoming:
            return APIPaths.Movie.upcoming
        }
    }
    
    private var languageParam: URLQueryItem {
        URLQueryItem(name: "language", value: APIConfig.languageCode)
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page), .nowPlaying(let page), .topRated(let page), .upcoming(let page):
            return [.init(name: "page", value: String(page)), languageParam]
        case .detail:
            return [languageParam]
        }
    }
    
    var method: HTTPMethod { .get }
}
