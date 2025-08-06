//
//  SearchViewModel.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import Foundation

protocol SearchViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    func search(query: String, page: Int) async
    func loadNextPage() async
    func movie(at indexPath: IndexPath) -> Movie
    func clearResults()
    
    var numberOfRowsInSection: Int { get }
}

final class SearchViewModel: SearchViewModelProtocol {
    private let searchService: SearchServiceProtocol
    private var movies: [Movie] = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    private var lastQuery = ""
    
    var numberOfRowsInSection: Int { movies.count }
    
    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }
    
    @MainActor
    func search(query: String, page: Int = 1) async {
        guard !isLoading, page <= totalPages else { return }
        isLoading = true
        onLoadingStateChange?(true)
        defer {
            isLoading = false
            onLoadingStateChange?(false)
        }
        
        do {
            let response = try await searchService.searchMovies(query: query, page: page)
            lastQuery = query
            currentPage = page
            totalPages = response.totalPages
            movies = page == 1 ? response.results : movies + response.results
            onDataUpdated?()
        } catch {
            onError?("Search failed: \(error.localizedDescription)")
        }
    }
    
    func loadNextPage() async {
        guard currentPage < totalPages else { return }
        await search(query: lastQuery, page: currentPage + 1)
    }
    
    func movie(at indexPath: IndexPath) -> Movie {
        guard indexPath.row < movies.count else {
            fatalError("Index out of range for movies array")
        }
        return movies[indexPath.row]
    }
    
    func clearResults() {
        movies.removeAll()
        currentPage = 1
        totalPages = 1
        lastQuery = ""
    }
}
