//
//  ImageEndpoint.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

import Foundation

enum ImageSize: String, Equatable {
    case w200
    case w500
    case original
}

enum ImageEndpoint: Endpoint, Equatable {
    case image(path: String, size: ImageSize)
    
    var baseURL: String {
        APIConfig.imageBaseURL
    }
    
    var path: String {
        switch self {
        case .image(let path, let size):
            return "/t/p/\(size.rawValue)\(path)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var method: HTTPMethod { .get }
}
