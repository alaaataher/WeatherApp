//
//  WeatherLoaderTests.swift
//  WeatherAppTests
//
//  Created by Alaa Taher on 07/10/2021.
//

import XCTest
@testable import WeatherApp


class WeatherLoaderTests: XCTestCase {
    func test_init_DoesNotRequestDataFromUrl() {
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedPaths.isEmpty)
    }

    func test_load_by_query_requestDataFromUrl() {
        let path = "/data/2.5/weather"
        let (sut,client) = makeSUT(path: path)
        sut.load(by: "cairo") {_ in}
        XCTAssertEqual(client.requestedPaths, [path])
    }

    func test_load_by_lat_lon_requestDataFromUrl() {
        let path = "/data/2.5/weather"
        let (sut,client) = makeSUT(path: path)
        sut.load(by: 122, lon: 122) {_ in}
        XCTAssertEqual(client.requestedPaths, [path])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        expect(sut, when: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversOn200WithValidJson() {
        let item = makeItem(temp: 11, pressure: 11, humidity: 11, lat: 22, lon: 33, weatherDescription: "cold", name: "cairo")
        let (sut,client) = makeSUT()
        expect(sut, when: .success(item.item)) {
            let json = makeItemJson(items: item.json)
            client.complete(with: 200, data: json)
        }
    }

    // helper methods
    private func makeSUT(path: String = "/data/2.5/weather", file: StaticString = #file, line: UInt = #line) -> (sut: RemoteWeatherLoader, client: HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteWeatherLoader(client: client, path: path)
        return (sut, client)
    }

    private func expect(_ sut: RemoteWeatherLoader, when expectedResult: WeatherLoaderResult, action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        sut.load(by: "") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(received), .success(expected)):
                XCTAssertEqual(received, expected, file: file, line: line)
            case let (.failure(received as RemoteWeatherLoader.Error), .failure(expected as RemoteWeatherLoader.Error)):
                XCTAssertEqual(received, expected, file: file, line: line)
            default:
                XCTFail("Faild")
            }
        }
        action()
    }

    private func makeItemJson(items: [String: Any]) -> Data {
        let json = try! JSONSerialization.data(withJSONObject: items)
        return json
    }

    private func makeItem(temp: Double, pressure: Double, humidity: Double, lat: Double, lon: Double, weatherDescription: String, name: String) -> (item: WeatherItem, json: [String: Any]) {
        let item = WeatherItem(temp: 11, pressure: 11, humidity: 11, lat: 22, lon: 33, weatherDescription: "cold", name: "cairo")
        let itemJson: [String: Any] = [
            "coord": ["lon": item.lon, "lat": item.lat],
            "weather": [["description": item.weatherDescription]],
            "main": ["temp":item.temp, "humidity": item.humidity, "pressure": item.pressure],
            "name": item.name
        ]
        return (item, itemJson)
    }
    private func failure(_ error: RemoteWeatherLoader.Error) -> WeatherLoaderResult {
        return .failure(error)
    }

    private class HttpClientSpy: HttpClient {
        var messages = [(path: String, completion: (HttpClientResult)->Void)]()
        var requestedPaths: [String] {
            messages.map {$0.path}
        }

        func get(from path: String, parameters: [String : String], completion: @escaping (HttpClientResult) -> Void) {
            messages.append((path, completion))
        }

        func complete(with error: Error, at index: Int = 0)  {
            messages[index].completion(.failure(error))
        }

        func complete(with statusCode: Int, data: Data, at index: Int = 0) {
            let httpRespone = HTTPURLResponse(url: URL(string: "http://" + messages[index].path)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, httpRespone))
        }
        
    }
}
