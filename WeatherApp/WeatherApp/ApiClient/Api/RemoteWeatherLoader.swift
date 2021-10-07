//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation

class RemoteWeatherLoader: WeatherLoader {
    private let client: HttpClient
    private let path: String
    private let parameters = ["appid":"35faf519a381659c6e55f6658aad3880", "units":"imperial"]

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

     func load(by query: String, completion: @escaping(WeatherLoaderResult)->Void) {
        var parameters = self.parameters
        parameters["q"] = query
        client.get(from: path, parameters: parameters) { [weak self] result in
            guard let self = self else {return}
            completion(self.configureHttpClientResult(result: result))
        }
    }

    func load(by lat: Double, lon: Double, completion: @escaping (WeatherLoaderResult) -> Void) {
        var parameters = self.parameters
        parameters["lat"] = "\(lat)"
        parameters["lon"] = "\(lon)"
        client.get(from: path, parameters: parameters) { [weak self] result in
            guard let self = self else {return}
            completion(self.configureHttpClientResult(result: result))
        }
    }

    private func configureHttpClientResult(result: HttpClientResult) -> WeatherLoaderResult{
        switch result {
        case .success(let data, let urlResponse):
            return WeatherItemMapper.map(data, urlResponse)
        case .failure:
            return .failure(Error.connectivity)
        }
    }
}
