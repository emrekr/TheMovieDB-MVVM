//
//  MovieListStrategy.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

protocol MovieListStrategy {
    var title: String { get }
    func endpoint(for page: Int) -> MovieEndpoint
}

struct PopularMoviesStrategy: MovieListStrategy {
    let title = String.moviesPopular
    func endpoint(for page: Int) -> MovieEndpoint { .popular(page: page) }
}

struct NowPlayingMoviesStrategy: MovieListStrategy {
    let title = String.moviesNowPlaying
    func endpoint(for page: Int) -> MovieEndpoint { .nowPlaying(page: page) }
}

struct TopRatedMoviesStrategy: MovieListStrategy {
    let title = String.moviesTopRated
    func endpoint(for page: Int) -> MovieEndpoint { .topRated(page: page) }
}

struct UpcomingMoviesStrategy: MovieListStrategy {
    let title = String.moviesUpcoming
    func endpoint(for page: Int) -> MovieEndpoint { .upcoming(page: page) }
}

