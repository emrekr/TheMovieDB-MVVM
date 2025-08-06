//
//  MovieSelectionDelegate.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

enum MovieSource {
    case moviesTab
    case searchTab
}

protocol MovieSelectionDelegate: AnyObject {
    func didSelectMovie(id: Int, source: MovieSource)
}

