//
//  HttpClient.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
public enum HttpClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
public protocol HttpClient {
    func get(from path: String, parameters: [String: String], completion: @escaping(HttpClientResult)->Void)
}
