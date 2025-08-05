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
    
    // MARK: - ViewModels
    private func makeMovieListViewModel() -> MovieListViewModelProtocol {
        let movieService = makeMovieService()
        return MovieListViewModel(movieService: movieService)
    }
    
    private func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModelProtocol {
        MovieDetailViewModel(movieDetailService: makeMovieDetailService(), movieId: movieId)
    }
    
    // MARK: - Services
    private func makeMovieService() -> MovieServiceProtocol {
        let networkService = makeNetworkService()
        return MovieService(networkService: networkService)
    }
    
    private func makeMovieDetailService() -> MovieDetailServiceProtocol {
        MovieDetailService(networkService: makeNetworkService())
    }
    
    // MARK: - Network
    private func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService(session: .shared, baseURL: APIConfig.baseURL, accessToken: APIConfig.apiKey)
    }
}
