//
//  MovieCell.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//

import UIKit

final class MovieCell: CardCell {
    static let reuseIdentifier = "MovieCell"
    private var currentImageEndpoint: ImageEndpoint?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let textStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        posterImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(overviewLabel)
        
        mainStackView.addArrangedSubview(posterImageView)
        mainStackView.addArrangedSubview(textStack)
        
        containerView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        if let posterPath = movie.posterPath {
            let endpoint = ImageEndpoint.image(path: posterPath, size: .w200)
            currentImageEndpoint = endpoint
            Task {
                if let image = await ImageLoader.shared.loadImage(from: endpoint),
                   currentImageEndpoint == endpoint {
                    posterImageView.image = image
                }
            }
        } else {
            posterImageView.image = nil
            currentImageEndpoint = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let endpoint = currentImageEndpoint {
            ImageLoader.shared.cancelLoad(for: endpoint)
        }
        posterImageView.image = nil
    }

}
