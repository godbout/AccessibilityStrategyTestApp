import XCTest
import AccessibilityStrategy


// using Monterey and SwiftUI, by default the TextField will always
// have the caret. so even if we tap on a button or the window, the focused AXUIElement
// will still be the TextField. therefore in order to get a AXUIElement that is not
// a TextField or TextView, we just mock pressing tab.
// edit: seems there's a change with Xcode 13.2. now the tab sends to the TextEditor and the
// test fail LMAO. so doing shift-tab now.
class NonTextElementsTests: ATEA_BaseTests {}


// from AXUIElement
extension NonTextElementsTests {
    
    func test_that_trying_to_convert_something_else_than_the_TextField_or_TextView_returns_nil() {
        app.typeKey(.tab, modifierFlags: [.shift])
     
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertNil(accessibilityElement)
    }

}
