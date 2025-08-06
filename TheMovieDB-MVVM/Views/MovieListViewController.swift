//
//  MovieListViewController.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

protocol MovieListViewControllerDelegate: AnyObject {
    func didSelectMovie(id: Int)
}

class MovieListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var viewModel: MovieListViewModelProtocol
    weak var delegate: MovieListViewControllerDelegate?
    
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

    private var menuCollectionView: UICollectionView!
    
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
        title = .moviesTitle
        view.backgroundColor = .systemBackground
        setupLoadingIndicator()
        setupMenuCollectionView()
        setupTableView()
        bindViewModel()
        
        DispatchQueue.main.async {
            self.menuCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
        
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
            tableView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        menuCollectionView.showsHorizontalScrollIndicator = false
        menuCollectionView.backgroundColor = .clear
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.register(MovieListCategoryCell.self, forCellWithReuseIdentifier: MovieListCategoryCell.reuseIdentifier)
        
        view.addSubview(menuCollectionView)
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            menuCollectionView.heightAnchor.constraint(equalToConstant: 40)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath)
        delegate?.didSelectMovie(id: movie.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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

//MARK: - UICollectionView Data Source and UICollectionView Delegate
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.strategyTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCategoryCell.reuseIdentifier, for: indexPath) as? MovieListCategoryCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.strategyTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.updateStrategyIndex(indexPath.item)
    }
}
