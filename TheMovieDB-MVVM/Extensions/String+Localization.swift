//
//  String+Localization.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

import Foundation

extension String {
    static let moviesTitle = NSLocalizedString("movies.title", comment: "Title for movies list screen")
    static let discoverTitle = NSLocalizedString("discover.title", comment: "Title for discover screen")
    
    static let moviesPopular = NSLocalizedString("movies.popular", comment: "Popular movies list title")
    static let moviesNowPlaying = NSLocalizedString("movies.nowPlaying", comment: "Now playing movies list title")
    static let moviesTopRated = NSLocalizedString("movies.topRated", comment: "Top rated movies list title")
    static let moviesUpcoming = NSLocalizedString("movies.upcoming", comment: "Upcoming movies list title")
}

