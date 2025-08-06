//
//  AppCoordinator.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencyInjector: DependencyInjector
    
    private var moviesNavigationController: UINavigationController?
    private var searchNavigationController: UINavigationController?
    
    init(navigationController: UINavigationController, dependencyInjector: DependencyInjector) {
        self.navigationController = navigationController
        self.dependencyInjector = dependencyInjector
    }
    
    func start() {
        let moviesNav = UINavigationController(rootViewController: makeMoviesList())
        moviesNav.tabBarItem = UITabBarItem(title: .moviesTitle,
                                            image: UIImage(systemName: "film"),
                                            selectedImage: UIImage(systemName: "film.fill"))
        self.moviesNavigationController = moviesNav
        
        let searchNav = UINavigationController(rootViewController: makeSearchViewController())
        searchNav.tabBarItem = UITabBarItem(title: .searchTitle,
                                              image: UIImage(systemName: "magnifyingglass"),
                                              selectedImage: UIImage(systemName: "magnifyingglass"))
        self.searchNavigationController = searchNav
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [moviesNav, searchNav]
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func makeMoviesList() -> UIViewController {
        let movieList = dependencyInjector.makeMovieListViewController()
        movieList.delegate = self
        return movieList
    }
    
    private func makeSearchViewController() -> UIViewController {
        let search = dependencyInjector.makeSearchViewController()
        search.delegate = self
        return search
    }
    
    private func showMovieDetail(id: Int, in navigationController: UINavigationController?) {
        guard let nav = navigationController else { return }
        let detailVC = dependencyInjector.makeMovieDetailViewController(movieId: id)
        nav.pushViewController(detailVC, animated: true)
    }
}

extension AppCoordinator: MovieSelectionDelegate {
    func didSelectMovie(id: Int, source: MovieSource) {
        switch source {
        case .moviesTab:
            showMovieDetail(id: id, in: moviesNavigationController)
        case .searchTab:
            showMovieDetail(id: id, in: searchNavigationController)
        }
    }
}
