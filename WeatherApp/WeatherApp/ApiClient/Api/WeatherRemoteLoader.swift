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
    
    enum Error: Swift.Error {
        case connectivity
        case notFound

        var title: String {
            switch self {
            case .connectivity:
                return "No internet connection"
            case .notFound:
                return "No Data Found"
            }
        }
    }

    public init(client: HttpClient = URLSessionHTTPClient(), path: String = "/data/2.5/weather") {
        self.client = client
        self.path = path
    }

    public func load(by query: String, completion: @escaping(WeatherLoaderResult)->Void) {
        let parameters = ["q": query, "appid":"35faf519a381659c6e55f6658aad3880", "units":"imperial"]
        client.get(from: path, parameters: parameters) { [weak self] result in
            guard let _ = self else {return}
            switch result {
            case .success(let data, let urlResponse):
                completion(WeatherItemMapper.map(data, urlResponse))
            case .failure: completion(.failure(Error.connectivity))
            }
        }
    }
}
