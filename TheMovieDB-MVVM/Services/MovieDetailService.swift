//
//  MovieDetailService.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse
}

final class MovieDetailService: MovieDetailServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse {
        try await networkService.request(MovieEndpoint.detail(id: id))
    }
}
