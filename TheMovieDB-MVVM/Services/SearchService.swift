//
//  SearchService.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import Foundation

protocol SearchServiceProtocol {
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse
}

final class SearchService: SearchServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        try await networkService.request(SearchEndpoint.movies(query: query, page: page))
    }
}
