import XCTest
import AccessibilityStrategy


class NonTextElementsTests: ATEA_BaseTests {}


// from AXUIElement
extension NonTextElementsTests {
    
    func test_that_trying_to_convert_anAXUIElement_window_to_an_AccessibilityTextElement_returns_nil() {
        app.windows.firstMatch.tap()
       
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertNil(accessibilityElement)
    }

    func test_that_trying_to_convert_an_AXUIElement_button_to_an_AccessibilityTextElement_returns_nil() {
        app.buttons.firstMatch.tap()

        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()

        XCTAssertNil(accessibilityElement)
    }

}
