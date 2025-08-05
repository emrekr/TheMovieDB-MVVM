//
//  MovieService.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int) async throws -> MovieListResponse
}

final class MovieService: MovieServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPopularMovies(page: Int) async throws -> MovieListResponse {
        try await networkService.request(MovieEndpoint.popular(page: page))
    }
}
