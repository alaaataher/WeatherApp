//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation

class WeatherRemoteLoader: WeatherLoader {
    private let client: HttpClient
    private let path: String
    var parameters: [String: String] = [:]
    
    public enum Error: Swift.Error {
        case connectivity
        case notFound
    }

    public init(client: HttpClient = URLSessionHTTPClient(), path: String = "/data/2.5/weather") {
        self.client = client
        self.path = path
    }

    public func load(completion: @escaping(WeatherLoaderResult)->Void) {
        client.get(from: path, parameters: parameters) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data, let urlResponse):
                completion(self.map(data, urlResponse))
            case .failure: completion(.failure(Error.connectivity))
            }
        }
    }

    private func map(_ data: Data, _ response: HTTPURLResponse) -> WeatherLoaderResult {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(WeatherDto.self, from: data) else {
            return .failure(WeatherRemoteLoader.Error.notFound)
        }
        return .success(root)
    }
}
