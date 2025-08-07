//
//  MovieDetailViewModel.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//
import Foundation

enum DetailSection: Int, CaseIterable {
    case cast
    case similar
}

protocol MovieDetailViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    var movie: MovieDetailResponse? { get }
    var trailerURL: URL? { get }
    
    func fetchAllData() async
    
    var numberOfCast: Int { get }
    var numberOfSimilarMovies: Int { get }
    
    func cast(at index: Int) -> Cast?
    func similarMovie(at index: Int) -> Movie?
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private let movieDetailService: MovieDetailServiceProtocol
    private let movieId: Int
    
    var onDataUpdated: (() -> Void)?
    
    var onError: ((String) -> Void)?
    
    private(set) var movie: MovieDetailResponse?
    private(set) var credits: CreditsResponse?
    private(set) var similarMovies: [Movie] = []
    private(set) var trailerURL: URL?
    
    
    var numberOfCast: Int { credits?.cast.count ?? 0 }
    var numberOfSimilarMovies: Int { similarMovies.count }
    
    func cast(at index: Int) -> Cast? {
        guard index >= 0, index < (credits?.cast.count ?? 0) else { return nil }
        return credits?.cast[index]
    }

    func similarMovie(at index: Int) -> Movie? {
        guard index >= 0, index < similarMovies.count else { return nil }
        return similarMovies[index]
    }

    
    init(movieDetailService: MovieDetailServiceProtocol, movieId: Int) {
        self.movieDetailService = movieDetailService
        self.movieId = movieId
    }
    
    @MainActor
    func fetchAllData() async {
        do {
            async let detailTask = movieDetailService.fetchMovieDetail(id: movieId)
            async let creditsTask = movieDetailService.fetchCredits(id: movieId)
            async let similarTask = movieDetailService.fetchSimilarMovies(id: movieId, page: 1)
            async let videosTask = movieDetailService.fetchVideos(id: movieId)
            
            let (detail, credits, similar, videos) = try await (detailTask, creditsTask, similarTask, videosTask)
            
            self.movie = detail
            self.credits = credits
            self.similarMovies = similar.results
            
            if let trailer = videos.results.first(where: {
                $0.type.lowercased() == "trailer" && $0.site.lowercased() == "youtube"
            }) {
                self.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
            }
            
            onDataUpdated?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
