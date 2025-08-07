//
//  CreditsResponse.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

struct CreditsResponse: Decodable {
    let cast: [Cast]
    let crew: [Crew]
}
