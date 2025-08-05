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
    
    init(navigationController: UINavigationController, dependencyInjector: DependencyInjector) {
        self.navigationController = navigationController
        self.dependencyInjector = dependencyInjector
    }
    
    func start() {
        let movieListVC = dependencyInjector.makeMovieListViewController()
        navigationController.pushViewController(movieListVC, animated: false)
    }
}
