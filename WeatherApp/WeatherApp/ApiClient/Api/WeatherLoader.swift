//
//  WeatherLoader.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
enum WeatherLoaderResult {
    case success(WeatherItem)
    case failure(Error)
}

protocol WeatherLoader {
    func load(by query: String, completion: @escaping(WeatherLoaderResult) -> Void)
    func load(by lat: Double, lon: Double, completion: @escaping(WeatherLoaderResult) -> Void)
}
