//
//  MovieDetailService.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse
    func fetchCredits(id: Int) async throws -> CreditsResponse
    func fetchSimilarMovies(id: Int, page: Int) async throws -> MovieListResponse
    func fetchVideos(id: Int) async throws -> VideosResponse
}

final class MovieDetailService: MovieDetailServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse {
        try await networkService.request(MovieEndpoint.detail(id: id))
    }
    
    func fetchCredits(id: Int) async throws -> CreditsResponse {
        try await networkService.request(MovieEndpoint.credits(id: id))
    }
    
    func fetchSimilarMovies(id: Int, page: Int) async throws -> MovieListResponse {
        try await networkService.request(MovieEndpoint.similar(id: id, page: page))
    }
    
    func fetchVideos(id: Int) async throws -> VideosResponse {
        try await networkService.request(MovieEndpoint.videos(id: id))
    }
}
