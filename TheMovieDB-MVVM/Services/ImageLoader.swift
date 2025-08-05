//
//  ImageLoader.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 5.08.2025.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from endpoint: ImageEndpoint) async -> UIImage?
    func cancelLoad(for endpoint: ImageEndpoint)
}

final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private var runningRequests: [NSURL: URLSessionDataTask] = [:]
    
    private init() {}
    
    func loadImage(from endpoint: ImageEndpoint) async -> UIImage? {
        guard let url = makeURL(from: endpoint) else { return nil }
        
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: url as NSURL)
                return image
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func cancelLoad(for endpoint: ImageEndpoint) {
        guard let url = makeURL(from: endpoint) else { return }
        runningRequests[url as NSURL]?.cancel()
        runningRequests.removeValue(forKey: url as NSURL)
    }
    
    private func makeURL(from endpoint: ImageEndpoint) -> URL? {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
}
