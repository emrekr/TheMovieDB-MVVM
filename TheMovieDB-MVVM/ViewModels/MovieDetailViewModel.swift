//
//  MovieDetailViewModel.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

protocol MovieDetailViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    func fetchMovieDetail() async
    var movie: MovieDetailResponse? { get }
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private let movieDetailService: MovieDetailServiceProtocol
    private let movieId: Int
    
    var onDataUpdated: (() -> Void)?
    
    var onError: ((String) -> Void)?
    
    var movie: MovieDetailResponse?
    
    init(movieDetailService: MovieDetailServiceProtocol, movieId: Int) {
        self.movieDetailService = movieDetailService
        self.movieId = movieId
    }
    
    @MainActor
    func fetchMovieDetail() async {
        do {
            movie = try await movieDetailService.fetchMovieDetail(id: movieId)
            onDataUpdated?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
