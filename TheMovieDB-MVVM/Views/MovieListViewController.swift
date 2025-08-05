//
//  MovieListViewController.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var viewModel: MovieListViewModelProtocol
    
    private let loadingFooterView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()


    init(viewModel: MovieListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = .systemBackground
        setupLoadingIndicator()
        setupTableView()
        bindViewModel()
        Task { await viewModel.fetchMovies(page: 1) }
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        setupRefreshControl()

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { error in
            print(error)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.loadingView.startAnimating()
            } else {
                self?.loadingView.stopAnimating()
            }
        }
    }
}

//MARK: - Loading Footer
extension MovieListViewController {
    private func showLoadingFooter() {
        tableView.tableFooterView = loadingFooterView
        loadingFooterView.startAnimating()
    }

    private func hideLoadingFooter() {
        loadingFooterView.stopAnimating()
        tableView.tableFooterView = UIView()
    }
}

//MARK: - Pull-to-Refresh
extension MovieListViewController {
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshMovies() {
        Task {
            hideLoadingFooter()
            await viewModel.fetchMovies(page: 1)
            tableView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - Loading Indicator
extension MovieListViewController {
    private func setupLoadingIndicator() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - UITableView Data Source
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.movie(at: indexPath))
        return cell
    }
}

//MARK: - UITableView Delegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.numberOfRowsInSection - 1
        if indexPath.row == lastIndex {
            showLoadingFooter()
            Task {
                await viewModel.fetchMovies(page: viewModel.nextPage)
                hideLoadingFooter()
            }
        }
    }
}
