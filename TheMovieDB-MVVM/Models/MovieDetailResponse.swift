//
//  MovieDetailResponse.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

struct MovieDetailResponse: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
