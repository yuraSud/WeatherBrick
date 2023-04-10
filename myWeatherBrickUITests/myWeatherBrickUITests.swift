
import XCTest
@testable import myWeatherBrick

final class myWeatherBrickUITests: XCTestCase {
    
    func testAppWeather() {
        let app = XCUIApplication()
        app.launch()
        
        let scrollViewsQuery = app.scrollViews
        let infoElement = scrollViewsQuery.otherElements.containing(.button, identifier:"INFO").element
        
        
        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssert(app.staticTexts["20.0"].exists)
        
        
        let iconLocationButton = elementsQuery.buttons["icon location"]
        iconLocationButton.tap()
        
        elementsQuery.buttons["icon search"].tap()
        app.alerts["Find City"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Input City name:"]/*[[".cells.textFields[\"Input City name:\"]",".textFields[\"Input City name:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Find City"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Input City name:"]/*[[".cells.textFields[\"Input City name:\"]",".textFields[\"Input City name:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("Paris")
        app.alerts["Find City"].scrollViews.otherElements.buttons["Find"].tap()
       
        XCTAssert(app.staticTexts["14.0"].exists)
       
        elementsQuery.buttons["INFO"].tap()
        
        XCTAssert(app.staticTexts["Hide"].exists)
        app.staticTexts["Hide"].tap()
       
        infoElement.tap()
        infoElement.swipeDown()
       
        XCTAssert(app.staticTexts["20.0"].exists)
        
   
        
    }

}
