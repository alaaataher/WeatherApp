//
//  URLSessionHTTPClient.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
class URLSessionHTTPClient: HttpClient {
    private let session: URLSession
    private let baseUrl = "api.openweathermap.org"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    func get(from path: String, parameters: [String: String], completion: @escaping (HttpClientResult) -> Void) {
        session.dataTask(with: buildUrlRequest(path, parameters)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            }
        }.resume()
    }

    private func buildUrlRequest(_ path: String, _ urlParameters: [String: String] = [:], _ httpMethod: String = "GET") -> URLRequest {
        let url = URL(string: self.baseUrl)!.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !urlParameters.isEmpty {
            urlComponents?.queryItems = urlParameters.map {key, value in
                URLQueryItem(name: key,
                             value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            }
        }
        var request = URLRequest(url: (urlComponents?.url!)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        request.httpMethod = httpMethod

        return request

    }
}
