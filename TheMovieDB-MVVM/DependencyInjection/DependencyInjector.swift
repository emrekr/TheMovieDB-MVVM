//
//  DependencyInjector.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

final class DependencyInjector {
    // MARK: - View Controllers
    func makeMovieListViewController() -> MovieListViewController {
        let viewModel = makeMovieListViewModel()
        return MovieListViewController(viewModel: viewModel)
    }
    
    func makeMovieDetailViewController(movieId: Int) -> MovieDetailViewController {
        let viewModel = makeMovieDetailViewModel(movieId: movieId)
        return MovieDetailViewController(viewModel: viewModel)
    }
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewModel()
        return SearchViewController(viewModel: viewModel)
    }
    
    // MARK: - ViewModels
    func makeMovieListViewModel() -> MovieListViewModelProtocol {
        let strategies: [MovieListStrategy] = [
            PopularMoviesStrategy(),
            NowPlayingMoviesStrategy(),
            TopRatedMoviesStrategy(),
            UpcomingMoviesStrategy()
        ]
        return MovieListViewModel(movieService: makeMovieService(), strategies: strategies)
    }
    
    private func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModelProtocol {
        MovieDetailViewModel(movieDetailService: makeMovieDetailService(), movieId: movieId)
    }
    
    private func makeSearchViewModel() -> SearchViewModelProtocol {
        SearchViewModel(searchService: makeSearchService())
    }
    
    // MARK: - Services
    private func makeMovieService() -> MovieServiceProtocol {
        let networkService = makeNetworkService()
        return MovieService(networkService: networkService)
    }
    
    private func makeMovieDetailService() -> MovieDetailServiceProtocol {
        MovieDetailService(networkService: makeNetworkService())
    }
    
    private func makeSearchService() -> SearchServiceProtocol {
        SearchService(networkService: makeNetworkService())
    }
    
    // MARK: - Network
    private func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService(session: .shared, baseURL: APIConfig.baseURL, accessToken: APIConfig.apiKey)
    }
}
