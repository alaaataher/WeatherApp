//
//  WeatherLoader.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
enum WeatherLoaderResult {
    case success(WeatherDto)
    case failure(Error)
}

protocol WeatherLoader {
    func load(completion: @escaping(WeatherLoaderResult) -> Void)
}
