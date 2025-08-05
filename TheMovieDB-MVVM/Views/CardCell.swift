//
//  CardCell.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

import UIKit

class CardCell: UITableViewCell {
    
    private let shadowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true // sadece içerik kesilsin
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        contentView.addSubview(shadowContainer)
        shadowContainer.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            shadowContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            shadowContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shadowContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shadowContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            containerView.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor)
        ])
    }
}

