//
//  myWeatherBrickTests.swift
//  myWeatherBrickTests
//
//  Created by YURA																			 on 10.03.2023.
//

import XCTest
@testable import myWeatherBrick

final class myWeatherBrickTests: XCTestCase {
    
    let weatherBrick = WeatherViewController(fetchManager: MockFetchWeather())
    
    func testWeatherForCityName() async throws {
        
        await weatherBrick.fetchManager?.fetchWeatherForCityName(cityName: "Testing city should be Paris", completionhandler: { weatherModel in
           
            guard let weather = weatherModel else {return}
            
            XCTAssertEqual(weather.temp, 14)
            XCTAssert(weather.nameCity == "Paris")
            XCTAssertFalse(weather.wind == 10)
        })
    }
        
    func testWeatherForCoordinates() {
        let expectation = expectation(description: "Weather data parsing for coordinates")
        
        var weatherDat: WeatherModel?
        
        weatherBrick.fetchManager?.fetchWeatherForCoordinates(latitude: 32.55, longitude: 47.54, completionhandler: { weatherModel in
            
            weatherDat = weatherModel
            
            expectation.fulfill()
        })
        
        XCTAssertNil(weatherDat)
        
        waitForExpectations(timeout: 15)
        // wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(weatherDat?.temp, 20)
        XCTAssertNotEqual(weatherDat?.temp, 30)
        XCTAssertFalse(weatherDat?.nameCity == "Paris")
        XCTAssert(weatherDat?.nameCity == "Kyiv")
    }
}
