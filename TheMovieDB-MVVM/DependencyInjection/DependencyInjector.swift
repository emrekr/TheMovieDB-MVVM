//
//  DependencyInjector.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

final class DependencyInjector {
    func makeMovieListViewController() -> MovieListViewController {
        let viewModel = makeMovieListViewModel()
        return MovieListViewController(viewModel: viewModel)
    }
    
    private func makeMovieListViewModel() -> MovieListViewModelProtocol {
        let movieService = makeMovieService()
        return MovieListViewModel(movieService: movieService)
    }
    
    private func makeMovieService() -> MovieServiceProtocol {
        let networkService = makeNetworkService()
        return MovieService(networkService: networkService)
    }
    
    private func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService(session: .shared, baseURL: APIConfig.baseURL, accessToken: APIConfig.apiKey)
    }
}
