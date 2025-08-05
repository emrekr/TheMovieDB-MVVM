//
//  MovieDetailViewController.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private var viewModel: MovieDetailViewModelProtocol
    
    private var currentImageEndpoint: ImageEndpoint?
    private var posterHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemYellow
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
        
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        Task { await viewModel.fetchMovieDetail() }
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(posterImageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(releaseDateLabel)
        contentStack.addArrangedSubview(voteLabel)
        contentStack.addArrangedSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self, let movie = self.viewModel.movie else { return }
            
            self.titleLabel.text = movie.title
            self.releaseDateLabel.text = "📅 \(movie.releaseDate)"
            self.voteLabel.text = "⭐️ \(String(format: "%.1f", movie.voteAverage))/10"
            self.overviewLabel.text = movie.overview
            
            if let posterPath = movie.posterPath {
                let endpoint = ImageEndpoint.image(path: posterPath, size: .original)
                self.currentImageEndpoint = endpoint
                
                Task {
                    if let image = await ImageLoader.shared.loadImage(from: endpoint),
                       self.currentImageEndpoint == endpoint {
                        
                        self.posterImageView.image = image
                        
                        self.posterHeightConstraint?.isActive = false
                        
                        let aspectRatio = image.size.height / image.size.width
                        self.posterHeightConstraint = self.posterImageView.heightAnchor.constraint(equalTo: self.posterImageView.widthAnchor, multiplier: aspectRatio)
                        self.posterHeightConstraint?.isActive = true
                    }
                }
            } else {
                self.posterImageView.image = UIImage(named: "posterPlaceholder")
                self.posterHeightConstraint?.isActive = false
            }
        }
        
        viewModel.onError = { error in
            print(error)
        }
    }
}

