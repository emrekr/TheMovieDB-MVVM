//
//  Cast.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 6.08.2025.
//

struct Cast: Decodable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}
