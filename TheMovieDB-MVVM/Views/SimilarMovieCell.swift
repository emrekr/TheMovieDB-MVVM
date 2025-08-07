//
//  SimilarMovieCell.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import UIKit

final class SimilarMovieCell: UICollectionViewCell {
    static let reuseIdentifier = "SimilarMovieCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .caption1)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let path = movie.posterPath {
            let endpoint = ImageEndpoint.image(path: path, size: .w200)
            Task {
                if let image = await ImageLoader.shared.loadImage(from: endpoint) {
                    imageView.image = image
                }
            }
        } else {
            imageView.image = nil
        }
    }
}

