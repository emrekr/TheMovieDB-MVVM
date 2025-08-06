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
    func showMovieDetail(id: Int)
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencyInjector: DependencyInjector
    
    private var moviesNavigationController: UINavigationController?
    
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
        
        let discoverNav = UINavigationController(rootViewController: makeDiscover())
        discoverNav.tabBarItem = UITabBarItem(title: .discoverTitle,
                                              image: UIImage(systemName: "magnifyingglass"),
                                              selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [moviesNav, discoverNav]
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func showMovieDetail(id: Int) {
        let movieDetailViewController = dependencyInjector.makeMovieDetailViewController(movieId: id)
        moviesNavigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    private func makeMoviesList() -> UIViewController {
        let movieList = dependencyInjector.makeMovieListViewController()
        movieList.delegate = self
        return movieList
    }
    
    private func makeDiscover() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = .discoverTitle
        return vc
    }
}

extension AppCoordinator: MovieListViewControllerDelegate {
    func didSelectMovie(id: Int) {
        showMovieDetail(id: id)
    }
}
