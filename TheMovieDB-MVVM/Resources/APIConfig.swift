//
//  APIConfig.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//
import Foundation

struct APIConfig {
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org"
    
    static let apiKey: String = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else {
            fatalError("Secrets.plist file is missing.")
        }
        do {
            let data = try Data(contentsOf: url)
            let secrets = try PropertyListDecoder().decode(Secrets.self, from: data)
            return secrets.tmdbAccessToken
        } catch {
            fatalError("Failed to load API key from Secrets.plist: \(error)")
        }
    }()
    
    static var languageCode: String {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("tr") {
            return "tr-TR"
        } else {
            return "en-US"
        }
    }
}

private struct Secrets: Decodable {
    let tmdbAccessToken: String
    
    enum CodingKeys: String, CodingKey {
        case tmdbAccessToken = "TMDBAccessToken"
    }
}
