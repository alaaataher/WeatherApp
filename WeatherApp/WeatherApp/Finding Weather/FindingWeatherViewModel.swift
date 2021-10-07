//
//  FindingWeatherViewModel.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation

class FindingWeatherViewModel {
    private let loader: WeatherLoader
    private let locationManger: LocationManger
    var isLoading: ((Bool)->Void)?
    var errorMessage: ((String)->Void)?
    var weatherItem: ((WeatherItem)->Void)?

    init(loader: WeatherLoader = WeatherRemoteLoader()) {
        self.loader = loader
        self.locationManger = LocationManger()
    }

    func loadWeatherInfo(with query: String) {
        isLoading?(true)
        loader.load(by: query) { [weak self] (result) in
            self?.configureWeatherLoadResult(result)
        }
    }

    func getCurrentLocation() {
        locationManger.getCurrenLocation {[weak self] (lat, lon) in
            self?.loader.load(by: lat, lon: lon) { (result) in
                self?.configureWeatherLoadResult(result)
            }
        }
    }

    private func configureWeatherLoadResult(_ result: WeatherLoaderResult) {
        self.isLoading?(false)
        switch result {
        case .success(let item):
            self.configureDataSource(with: item)
        case .failure(let err):
            self.configureError(with: err)
        }
    }

    private func configureError(with error: Error) {
        if let err = error as? WeatherRemoteLoader.Error {
            self.errorMessage?(err.title)
        }
    }

    private func configureDataSource(with item: WeatherItem) {
        self.weatherItem?(item)
    }
}
