//
//  WeatherItemMapper.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
internal class WeatherItemMapper {
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> WeatherLoaderResult {
        guard response.statusCode == 200, let dto = try? JSONDecoder().decode(WeatherDto.self, from: data) else {
            return .failure(WeatherRemoteLoader.Error.notFound)
        }
        
        let item = WeatherItem(temp: dto.main?.temp ?? 0,
                               pressure: dto.main?.pressure ?? 0,
                               humidity: dto.main?.humidity ?? 0,
                               lat: dto.coord?.lat ?? 0,
                               lon: dto.coord?.lon ?? 0,
                               weatherDescription: dto.weather?.description ?? "")
        return .success(item)
    }
}
