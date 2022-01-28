import XCTest
import AccessibilityStrategy


// using Monterey and SwiftUI, by default the TextField will always
// have the caret. so even if we tap on a button or the window, the focused AXUIElement
// will still be the TextField. therefore in order to get a AXUIElement that is not
// a TextField or TextView, we just mock pressing tab.
// edit: seems there's a change with Xcode 13.2. now the tab sends to the TextEditor and the
// test fail LMAO. so doing shift-tab now.
// edit: removing the `tab to controls` in my own Monterey settings make the test fail. the caret
// always stays in a TextField or TextView. so i've added some code in the UITestsView that if you
// press the button, then the app gives up being first responder. so only then the app loses the focus.
class NonTextElementsTests: ATEA_BaseTests {}


// from AXUIElement
extension NonTextElementsTests {
    
    func test_that_trying_to_convert_something_else_than_the_TextField_or_TextView_returns_nil() {
        app.buttons.firstMatch.tap()
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertNil(accessibilityElement)
    }

}
