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
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let voteLabel = UILabel()
    private let overviewLabel = UILabel()
    
    private lazy var castCollectionView = makeCollectionView(itemSize: CGSize(width: 100, height: 150), cellType: CastCell.self, reuseIdentifier: CastCell.reuseIdentifier)
    private lazy var similarCollectionView = makeCollectionView(itemSize: CGSize(width: 100, height: 180), cellType: SimilarMovieCell.self, reuseIdentifier: SimilarMovieCell.reuseIdentifier)
    
    private lazy var trailerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("🎬 \(String.watchTrailerTitle)", for: .normal)
        btn.addTarget(self, action: #selector(trailerTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
        Task { await viewModel.fetchAllData() }
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        setupPosterSection()
        setupInfoSection()
        setupCastSection()
        setupSimilarSection()
        setupTrailerButton()
        
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
    
    private func setupPosterSection() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .systemGray5
        contentStack.addArrangedSubview(posterImageView)
    }
    
    private func setupInfoSection() {
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0
        
        releaseDateLabel.font = .preferredFont(forTextStyle: .subheadline)
        releaseDateLabel.textColor = .secondaryLabel
        
        voteLabel.font = .preferredFont(forTextStyle: .subheadline)
        voteLabel.textColor = .systemYellow
        
        overviewLabel.font = .preferredFont(forTextStyle: .body)
        overviewLabel.numberOfLines = 0
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(releaseDateLabel)
        contentStack.addArrangedSubview(voteLabel)
        contentStack.addArrangedSubview(overviewLabel)
    }
    
    private func setupCastSection() {
        contentStack.addArrangedSubview(sectionTitle(.castTitle))
        castCollectionView.dataSource = self
        contentStack.addArrangedSubview(castCollectionView)
        castCollectionView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    private func setupSimilarSection() {
        contentStack.addArrangedSubview(sectionTitle(.similarMoviesTitle))
        similarCollectionView.dataSource = self
        similarCollectionView.delegate = self
        contentStack.addArrangedSubview(similarCollectionView)
        similarCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupTrailerButton() {
        contentStack.addArrangedSubview(trailerButton)
    }
    
    private func sectionTitle(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .preferredFont(forTextStyle: .headline)
        return lbl
    }
    
    private func makeCollectionView<T: UICollectionViewCell>(itemSize: CGSize, cellType: T.Type, reuseIdentifier: String) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }

    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.updateUI()
        }
        viewModel.onError = { error in
            print(error)
        }
    }
    
    private func updateUI() {
        guard let movie = viewModel.movie else { return }
        
        titleLabel.text = movie.title
        releaseDateLabel.text = "📅 \(movie.releaseDate)"
        voteLabel.text = "⭐️ \(String(format: "%.1f", movie.voteAverage))/10"
        overviewLabel.text = movie.overview
        trailerButton.isHidden = viewModel.trailerURL == nil
        
        if let posterPath = movie.posterPath {
            loadPosterImage(posterPath)
        }
        
        castCollectionView.reloadData()
        similarCollectionView.reloadData()
    }
    
    private func loadPosterImage(_ path: String) {
        let endpoint = ImageEndpoint.image(path: path, size: .original)
        currentImageEndpoint = endpoint
        
        Task {
            if let image = await ImageLoader.shared.loadImage(from: endpoint),
               currentImageEndpoint == endpoint {
                posterImageView.image = image
                updatePosterHeight(with: image)
            }
        }
    }
    
    private func updatePosterHeight(with image: UIImage) {
        posterHeightConstraint?.isActive = false
        let aspectRatio = image.size.height / image.size.width
        posterHeightConstraint = posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: aspectRatio)
        posterHeightConstraint?.isActive = true
    }
    
    // MARK: - Actions
    @objc private func trailerTapped() {
        guard let url = viewModel.trailerURL else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return viewModel.numberOfCast
        }
        return viewModel.numberOfSimilarMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseIdentifier, for: indexPath) as! CastCell
            if let cast = viewModel.cast(at: indexPath.row) {
                cell.configure(with: cast)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.reuseIdentifier, for: indexPath) as! SimilarMovieCell
        if let movie = viewModel.similarMovie(at: indexPath.row) {
            cell.configure(with: movie)
        }
        return cell
    }
}
