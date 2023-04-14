
import XCTest
import SnapshotTesting
@testable import myWeatherBrick

final class myWeatherBrickSnapShotTests: XCTestCase {

    var vc : WeatherViewController!
    
    override func setUp() {
        vc = WeatherViewController()
        vc.fetchManager = MockFetchWeather()
    }
    
    override func tearDown() {
        vc = nil
    }
    
    func testMyViewController() {
        
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
    
    func testInfoView() {
        let infoView = InfoView()
        assertSnapshot(matching: infoView, as: .image)
    }
    
    func testTempLabel() {
        let tempLabel = vc.temperatureLabel
        assertSnapshot(matching: tempLabel, as: .image)
    }
}
