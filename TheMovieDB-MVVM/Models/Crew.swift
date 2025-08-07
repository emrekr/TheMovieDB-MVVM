//
//  Crew.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

struct Crew: Decodable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?
}
