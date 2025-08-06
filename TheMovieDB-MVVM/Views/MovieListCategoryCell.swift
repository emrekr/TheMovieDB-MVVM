//
//  MenuCell.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

import UIKit

final class MovieListCategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "MenuCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            underlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        
        updateAppearance()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func updateAppearance() {
        if isSelected {
            titleLabel.textColor = .systemBlue
            underlineView.isHidden = false
        } else {
            titleLabel.textColor = .secondaryLabel
            underlineView.isHidden = true
        }
    }
}

