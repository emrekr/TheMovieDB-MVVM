//
//  SeachEndpoint.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import Foundation

enum SearchEndpoint: Endpoint, Equatable {
    case movies(query: String, page: Int)
    
    var baseURL: String { APIConfig.baseURL }
    
    var path: String {
        switch self {
        case .movies:
            return APIPaths.Search.movie
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .movies(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "language", value: APIConfig.languageCode)
            ]
        }
    }
    
    var method: HTTPMethod { .get }
}
