//
//  CastCell.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import UIKit

final class CastCell: UICollectionViewCell {
    static let reuseIdentifier = "CastCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .caption1)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let roleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .caption2)
        lbl.textColor = .secondaryLabel
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, roleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        roleLabel.text = cast.character
        if let path = cast.profilePath {
            let endpoint = ImageEndpoint.image(path: path, size: .w200)
            Task {
                if let image = await ImageLoader.shared.loadImage(from: endpoint) {
                    imageView.image = image
                }
            }
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill") // SF Symbol placeholder
            imageView.tintColor = .systemGray3
            imageView.contentMode = .scaleAspectFit
        }
    }
}
