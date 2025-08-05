//
//  MovieListViewModel.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import Foundation

protocol MovieListViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    func fetchMovies(page: Int) async
    func movie(at indexPath: IndexPath) -> Movie
    
    var numberOfRowsInSection: Int { get }
    var nextPage: Int { get }
}

class MovieListViewModel: MovieListViewModelProtocol {
    private let movieService: MovieServiceProtocol
    private var movies: [Movie] = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    var nextPage: Int { currentPage + 1 }
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    @MainActor
    func fetchMovies(page: Int = 1) async {
        guard !isLoading, page <= totalPages else { return }
        isLoading = true
        onLoadingStateChange?(true)
        defer {
            isLoading = false
            onLoadingStateChange?(false)
        }
        
        do {
            let response = try await movieService.fetchPopularMovies(page: page)
            currentPage = page
            totalPages = response.totalPages
            if page == 1 {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            onDataUpdated?()
        } catch {
            onError?("Failed to load movies: \(error.localizedDescription)")
        }
    }

    
    var numberOfRowsInSection: Int {
        return movies.count
    }
    
    func movie(at indexPath: IndexPath) -> Movie {
        guard indexPath.row < movies.count else {
            fatalError("Index out of range for movies array")
        }
        return movies[indexPath.row]
    }
}
