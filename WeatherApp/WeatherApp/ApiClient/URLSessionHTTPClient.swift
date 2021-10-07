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
        var component:URLComponents = URLComponents()
        component.host = baseUrl
        component.scheme = "https"
        component.path = path
        urlParameters.forEach{
            if component.queryItems == nil{
                component.queryItems = []
            }
            component.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        print(component.url ?? "")
        var urlRequest = URLRequest(url:component.url!)
        urlRequest.httpMethod = "GET"
        return urlRequest

    }
}
