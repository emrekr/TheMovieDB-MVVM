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
    
    var baseURL: String {
        APIConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .detail(let id):
            return "/movie/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "language", value: APIConfig.languageCode)
            ]
        case .detail:
            return [
                URLQueryItem(name: "language", value: APIConfig.languageCode)
            ]
        }
    }
    
    var method: HTTPMethod { .get }
}
